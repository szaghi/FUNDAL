call dev_memcpy_from_device(dst=t, src=t_dev)
! the sine arch is an eigenvector of the scheme: each step multiplies it by g = 1 - 4 r sin(pi dx/2)**2
exact = (1._R8P - 4._R8P * r * sin(pi * dx / 2._R8P)**2)**steps * [(sin(pi*i*dx), i=0, n+1)]
exact(0) = 0._R8P ; exact(n+1) = 0._R8P
print '(A,I0,A,F7.5)', 'temperature at the centre after ', steps, ' steps: ', t((n+1)/2)
print '(A,L1)', 'equal to the exact discrete solution: ', maxval(abs(t - exact)) < 1.e-12_R8P
