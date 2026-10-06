bb(1,:) = [1, 1] ; bb(2,:) = [2, 3] ! a_dev(1:2,1:3)
tb(1,:) = [1, 1] ; tb(2,:) = [3, 2] ! at(1:3,1:2)
call dev_memcpy_from_device(bb=bb, tb=tb, dst=at, src=a_dev, buf=buf) ! at = transpose(a_dev), through buf
print '(A,L1)', 'at == transpose(a): ', all(at == transpose(a))
call dev_assign_from_device(dst=bt, src=b_dev, ij=[1,3])             ! bt(k,j,i) = b_dev(i,j,k), allocated
print '(A,3(I0,1X))', 'shape of bt: ', shape(bt)
print '(A,L1)', 'bt(k,j,i) == b(i,j,k): ', all([(((bt(k,j,i) == b(i,j,k), i=1, 2), j=1, 3), k=1, 4)])
