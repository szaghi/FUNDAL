
#!/bin/bash -

for t in $( find exe/ -executable -type f -name *_test ); do
  echo $t
  $t > test.out
  result=`tail -n 1 test.out`
  rm -f test.out
  echo $result
  if [ "$result" != "test passed" ] ; then
    echo 'error: test failed!'
    exit 1
  else
    echo $result
  fi
done
