#!/usr/bin/env bash
# Build and run the documentation examples, regenerating everything the pages include from them.
#
#   docs/examples/src/*.F90    the example programs (hand-written), with marker comments:
#                                !run ID COMMAND        a run shown in the pages (!run -s: with its exit status)
#                                !region NAME ... !endregion NAME   a part of the program included on its own
#   docs/examples/snippets/    generated: <program>.F90 without the markers, and <program>-<region>.F90 (dedented)
#   docs/examples/output/      generated: <ID>.txt, "$ COMMAND" then its standard output (and [exit status N] with -s)
#
# The library is built by the makefile with gfortran and the OpenACC backend (as the CI coverage job), with the MPI handler
# (MPI=1), through the MPI wrapper of gfortran ($MPIFC, default mpif90): the library and every example are compiled by the
# wrapper, so the MPI examples (mpirun --oversubscribe -np 2 ...) run like the serial ones. Every run uses the host on
# purpose (ACC_DEVICE_TYPE=host, the explicit host request of dev_init: no fallback warning). Outputs therefore do not
# depend on the machine: the examples must print only values (use explicit formats), never device names, memory sizes or
# timings, and an MPI example prints from rank 0 only, after gathering the results there. Run-dependent values (buffer
# addresses in dev_alloc_report) are replaced by placeholders. Each run happens in a scratch directory with a minimal
# environment (PATH: the examples, the directory of mpirun, /usr/bin, /bin), no standard input (mpirun would read it)
# and no GPU visible. The Docs examples workflow fails when the committed snippets or outputs differ from the regenerated
# ones.
#
# Usage: bash scripts/docs_examples.sh      (MPIFC=/path/to/mpif90 bash scripts/docs_examples.sh: another MPI wrapper;
#                                            the wrapper must wrap gfortran, and its mpirun must be next to it or on PATH)
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ex=$root/docs/examples
build=$root/build/docs-examples # git-ignored
lib=$root/build/gnu-oac         # the makefile output for COMPILER=gnu BACKEND=oac
run_dir=$build/run
home=/home/user                 # how the run directory is shown

fc=${MPIFC:-mpif90}
command -v "$fc" > /dev/null || { echo "docs_examples: MPI wrapper '$fc' not found (set MPIFC)" >&2; exit 1; }
fc=$(command -v "$fc")
mpirun=$(dirname "$fc")/mpirun
[ -x "$mpirun" ] || mpirun=$(command -v mpirun) || { echo "docs_examples: mpirun not found" >&2; exit 1; }
mkdir -p "$root/build"
(cd "$root" && make clean COMPILER=gnu BACKEND=oac && make -j4 lib COMPILER=gnu BACKEND=oac MPI=1 MPIFC="$fc") \
  > "$root/build/docs-examples.log" 2>&1 || {
  cat "$root/build/docs-examples.log"; echo "docs_examples: library build failed" >&2; exit 1; }
rm -rf -- "$build"
mkdir -p "$build/bin" "$build/mod" "$run_dir" "$ex/snippets" "$ex/output"
rm -f -- "$ex"/snippets/*.F90 "$ex"/output/*.txt

markers='^ *!(run|region|endregion) '
# snippets: the whole program and each region, without the markers, dedented
dedent() { awk '{l[NR]=$0; if ($0 ~ /[^ ]/) {match($0, /^ */); if (m == "" || RLENGTH < m) m = RLENGTH}}
                END {for (i = 1; i <= NR; i++) print substr(l[i], m + 1)}' "$1"; }
for src in "$ex"/src/*.F90; do
  name=$(basename "$src" .F90)
  grep -Ev "$markers" "$src" > "$ex/snippets/$name.F90" || true
  for region in $(sed -n 's/^ *!region \([A-Za-z0-9_-]*\).*/\1/p' "$src"); do
    awk -v r="$region" '$1 == "!endregion" && $2 == r {on = 0}
                        on && $0 !~ /^ *!(run|region|endregion) / {print}
                        $1 == "!region" && $2 == r {on = 1}' "$src" > "$build/region.F90"
    dedent "$build/region.F90" > "$ex/snippets/$name-$region.F90"
  done
done

# programs: compiled exactly as a user program built against the library
for src in "$ex"/src/*.F90; do
  "$fc" -cpp -DCOMPILER_GNU -DDEV_OAC -fopenacc -I"$root/src/lib" -I"$lib/mod" -J"$build/mod" \
        -o "$build/bin/$(basename "$src" .F90)" "$src" "$lib/libfundal.a"
done

# runs, in the order of the files and of the lines
path=$build/bin:$(dirname "$mpirun")
run() { # run [-s] ID COMMAND
  local show=0 status=0
  if [ "$1" = -s ]; then show=1; shift; fi
  local id=$1; shift
  local cmd="$*"
  {
    printf '$ %s\n' "$cmd"
    (cd "$run_dir" && env -i HOME="$run_dir" PATH="$path:/usr/bin:/bin" SHELL=/bin/bash LC_ALL=C \
                     ACC_DEVICE_TYPE=host CUDA_VISIBLE_DEVICES= OMP_NUM_THREADS=1 \
                     GFORTRAN_UNBUFFERED_PRECONNECTED=y bash -c "$cmd" < /dev/null 2>/dev/null) || status=$?
    if [ $show = 1 ]; then printf '[exit status %d]\n' "$status"; fi
  } | sed -E -e "s|$run_dir|$home|g" -e 's/address=0x[0-9A-F]{16}/address=0x<address>/g' > "$ex/output/$id.txt"
}
for src in "$ex"/src/*.F90; do
  while IFS= read -r line; do
    line=${line#*!run }
    if [ "${line%% *}" = -s ]; then line=${line#-s }; run -s "${line%% *}" "${line#* }"
    else run "${line%% *}" "${line#* }"; fi
  done < <(grep -E '^ *!run ' "$src" || true)
done
echo "docs_examples: $(ls "$ex"/src/*.F90 | wc -l) programs, $(ls "$ex"/output/*.txt | wc -l) runs"
