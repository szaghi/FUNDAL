call solver%init(t=t, r=r, ierr=ierr)
if (ierr /= 0) error stop 'device allocation failed'
call solver%run(steps=steps)
call solver%get(t=t)
call solver%destroy
