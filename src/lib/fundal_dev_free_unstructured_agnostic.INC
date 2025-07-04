   subroutine DEV_FREE_KKP_1D(fptr)
   !< Free array from device, KKP kind, rank 1.
   VARTYPE(KKP), intent(inout) :: fptr(:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_1D

   subroutine DEV_FREE_KKP_2D(fptr)
   !< Free array from device, KKP kind, rank 2.
   VARTYPE(KKP), intent(inout) :: fptr(:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_2D

   subroutine DEV_FREE_KKP_3D(fptr)
   !< Free array from device, KKP kind, rank 3.
   VARTYPE(KKP), intent(inout) :: fptr(:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_3D

   subroutine DEV_FREE_KKP_4D(fptr)
   !< Free array from device, KKP kind, rank 4.
   VARTYPE(KKP), intent(inout) :: fptr(:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_4D

   subroutine DEV_FREE_KKP_5D(fptr)
   !< Free array from device, KKP kind, rank 5.
   VARTYPE(KKP), intent(inout) :: fptr(:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_5D

   subroutine DEV_FREE_KKP_6D(fptr)
   !< Free array from device, KKP kind, rank 6.
   VARTYPE(KKP), intent(inout) :: fptr(:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_6D

   subroutine DEV_FREE_KKP_7D(fptr)
   !< Free array from device, KKP kind, rank 7.
   VARTYPE(KKP), intent(inout) :: fptr(:,:,:,:,:,:,:) !< Memory device pointer.
   !$acc exit data delete(fptr)
   !$omp target exit data map(delete:fptr)
   endsubroutine DEV_FREE_KKP_7D
