
#!/bin/bash -

for t in $( find exe/ -executable -type f -name *_test ); do
  echo $t
  if [[ $t == *"mpi"* ]]; then
     mpirun -np 2 $t > test.out
  else
     $t > test.out
  fi
  result=`tail -n 1 test.out`
  rm -f test.out
  echo $result
  if [ "$result" != "test passed" ] ; then
    echo 'error: test failed!'
    exit 1
  fi
done
