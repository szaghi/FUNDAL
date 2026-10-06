!< FUNDAL, allocation registry unit test (host only, no device memory involved).

program fundal_registry_test
!< FUNDAL, allocation registry unit test (host only, no device memory involved).
!< Model-based: random insert/remove/lookup sequences on synthetic aligned addresses are checked against a plain array
!< model, covering collisions, backward-shift deletion and growth; range lookups (sections) are checked against a brute-force
!< search; then totals, per-device stats, report and policy.

use, intrinsic :: iso_c_binding,   only : c_intptr_t
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
use            :: fundal_env,      only : dev_allocs_live, dev_bytes_live
use            :: fundal_registry

implicit none
integer(I4P), parameter :: POOL=3000_I4P   !< Number of distinct synthetic addresses.
integer(I4P), parameter :: OPS=20000_I4P   !< Random operations.
logical                 :: live(POOL)      !< Model: address registered.
integer(I8P)            :: size_(POOL)     !< Model: bytes of the address.
integer(I4P)            :: dev_(POOL)      !< Model: device of the address.
type(registry_entry)    :: entry           !< Registry entry.
logical                 :: found, replaced !< Flags.
logical                 :: overflow        !< Range lookup flag.
logical                 :: found_, overflow_ !< Brute-force range lookup.
integer(c_intptr_t)     :: a               !< Range start.
integer(I8P)            :: l               !< Range length.
integer(I4P)            :: j, nrange       !< Counters.
integer(I8P)            :: allocs, bytes   !< Stats.
integer(I4P)            :: op, k, ierr, u  !< Counters, status, unit.
real                    :: r               !< Random number.
integer, allocatable    :: seed(:)         !< Random seed.
character(256)          :: line            !< Report line.
integer(I4P)            :: nlines          !< Report lines.

call random_seed(size=k) ; allocate(seed(k)) ; seed = 20261005 ; call random_seed(put=seed)
live = .false. ; size_ = 0_I8P ; dev_ = 0_I4P
call registry_clear()

print '(A)', 'random insert/remove/lookup/range lookup against a model'
nrange = 0
do op=1, OPS
   call random_number(r) ; k = min(1_I4P + int(r * POOL, I4P), POOL)
   call random_number(r)
   if (r < 0.55) then
      size_(k) = int(8 * (1 + mod(k, 32_I4P)), I8P) ; dev_(k) = mod(k, 3_I4P) ! <= 256 bytes: disjoint allocations
      call registry_insert(addr(k), size_(k), dev_(k), label='a', replaced=replaced)
      call check(replaced .eqv. live(k), 'replaced flag')
      live(k) = .true.
   elseif (r < 0.85) then
      call registry_remove(addr(k), found, entry)
      call check(found .eqv. live(k), 'remove found flag')
      if (found) call check(entry%bytes == size_(k) .and. entry%dev_id == dev_(k), 'removed entry content')
      live(k) = .false.
   elseif (r < 0.92) then
      call registry_lookup(addr(k), found, entry)
      call check(found .eqv. live(k), 'lookup found flag')
      if (found) call check(entry%bytes == size_(k) .and. entry%dev_id == dev_(k), 'looked up entry content')
   else
      ! range [a, a+l) starting anywhere in the 256 bytes after addr(k), possibly beyond its allocation or in a gap
      call random_number(r) ; a = addr(k) + int(r * 256, c_intptr_t)
      call random_number(r) ; l = 1_I8P + int(r * 64, I8P)
      call registry_lookup_range(a, l, found, entry, overflow)
      found_ = .false. ; overflow_ = .false.
      do j=1, POOL
         if (.not.live(j)) cycle
         if (addr(j) <= a .and. a < addr(j) + size_(j)) then
            found_ = (a + l <= addr(j) + size_(j))
            overflow_ = .not.found_
            if (found_) call check(entry%addr == addr(j) .and. entry%dev_id == dev_(j), 'range lookup entry')
         endif
      enddo
      call check((found .eqv. found_) .and. (overflow .eqv. overflow_), 'range lookup against brute force')
      nrange = nrange + 1
   endif
   call check(dev_allocs_live == count(live, kind=I8P), 'live count mirrored in fundal_env')
   call check(dev_bytes_live == sum(size_, mask=live), 'live bytes mirrored in fundal_env')
enddo
do k=1, POOL ! full sweep: every address agrees with the model
   call registry_lookup(addr(k), found, entry)
   call check(found .eqv. live(k), 'final sweep')
enddo
print '(A,I0,A)', '    live entries at the end: ', count(live), ' (table grown past several doublings)'
print '(A,I0)', '    range lookups checked: ', nrange

print '(A)', 'per-device stats'
do k=0, 2
   call registry_stats(allocs=allocs, bytes=bytes, dev_id=k)
   call check(allocs == count(live .and. dev_ == k, kind=I8P), 'per-device count')
   call check(bytes == sum(size_, mask=live .and. dev_ == k), 'per-device bytes')
enddo
call registry_stats(allocs=allocs, bytes=bytes)
call check(allocs == count(live, kind=I8P) .and. bytes == sum(size_, mask=live), 'global stats')

print '(A)', 'drain to empty, then null address is ignored'
do k=1, POOL
   if (live(k)) call registry_remove(addr(k), found)
   live(k) = .false.
enddo
call check(dev_allocs_live == 0_I8P .and. dev_bytes_live == 0_I8P, 'drained')
call registry_insert(0_c_intptr_t, 8_I8P, 0_I4P)
call check(dev_allocs_live == 0_I8P, 'null address not registered')

print '(A)', 'report, in ascending address order'
call registry_insert(addr(2), 32_I8P, 0_I4P)
call registry_insert(addr(1), 64_I8P, 1_I4P, label='rho')
open(newunit=u, status='scratch')
call registry_report(unit=u)
rewind(u) ; nlines = 0
do
   read(u, '(A)', iostat=ierr) line ; if (ierr /= 0) exit
   nlines = nlines + 1
   if (nlines == 1) call check(index(line, 'label="rho"') > 0, 'lowest address first')
   if (index(line, 'label="rho"') > 0) call check(index(line, 'bytes=64') > 0 .and. index(line, 'device=1') > 0, &
                                                  'report line content')
enddo
close(u)
call check(nlines == 3, 'report has two entries and a summary')
call registry_clear()
call check(dev_allocs_live == 0_I8P, 'clear')

print '(A)', 'policy'
call dev_set_registry_policy('error', ierr) ; call check(ierr == 0 .and. registry_policy() == FUNDAL_REGISTRY_ERROR, 'error')
call dev_set_registry_policy('Off', ierr)   ; call check(ierr == 0 .and. registry_policy() == FUNDAL_REGISTRY_OFF, 'off')
call dev_set_registry_policy('bogus', ierr) ; call check(ierr == 1 .and. registry_policy() == FUNDAL_REGISTRY_OFF, 'bogus')
call dev_set_registry_policy('WARN', ierr)  ; call check(ierr == 0 .and. registry_policy() == FUNDAL_REGISTRY_WARN, 'warn')

print '(A)', 'test passed'

contains
   pure function addr(k) result(a)
   !< Synthetic 256-byte aligned address of pool element k (clustered, as device buffers are).
   integer(I4P), intent(in) :: k !< Pool index.
   integer(c_intptr_t)      :: a !< Address.

   a = int(z'7F0000000000', c_intptr_t) + int(k, c_intptr_t) * 256_c_intptr_t
   endfunction addr

   subroutine check(condition, msg)
   !< Stop with an error message if condition is false.
   logical,      intent(in) :: condition !< Condition to verify.
   character(*), intent(in) :: msg       !< Error message.

   if (.not.condition) then
      print '(A)', 'error: '//trim(adjustl(msg))
      error stop 1
   endif
   endsubroutine check
endprogram fundal_registry_test
