!< FUNDAL, device handling module.

#include "fundal.H"

module fundal_dev_handling
!< FUNDAL, device handling module.
use, intrinsic :: iso_c_binding,   only : C_SIZE_T
#if defined DEV_HIP
use, intrinsic :: iso_c_binding,   only : C_CHAR, C_INT, C_NULL_CHAR
#endif
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64
#if defined DEV_OAC
use            :: openacc,         only :                      acc_get_device_num,       &
                                          dev_get_device_type=>acc_get_device_type,      &
                                                               acc_get_num_devices,      &
                                                               acc_get_property,         &
                                                               acc_get_property_string,  &
                                                               acc_init,                 &
                                                               acc_set_device_num,       &
                                                               ACC_DEVICE_HOST,          &
                                                               ACC_PROPERTY_MEMORY,      &
                                                               ACC_PROPERTY_FREE_MEMORY, &
                                                               ACC_PROPERTY_NAME,        &
                                                               ACC_PROPERTY_VENDOR,      &
                                                               ACC_PROPERTY_DRIVER
#elif defined DEV_OMP
use            :: omp_lib,         only : dev_get_device_num =>omp_get_default_device, &
                                          dev_get_host_num   =>omp_get_initial_device, &
                                          dev_get_num_devices=>omp_get_num_devices,    &
                                          dev_set_device_num =>omp_set_default_device
use            :: fundal_env,      only : FUNDAL_DEVICE_HOST, FUNDAL_DEVICE_GPU
#endif
use            :: fundal_env,      only : devs_number, mydev, devtype, dev_memory_avail, myhos

implicit none
private
public :: dev_get_device_memory_info
public :: dev_get_device_num
public :: dev_get_device_type
public :: dev_get_host_num
public :: dev_get_num_devices
public :: dev_get_property_string
public :: dev_init
public :: dev_set_device_num

#if defined DEV_HIP
! HIP runtime C interfaces.
! @NOTE Available only for AMD/ROCm builds (DEV_HIP, set by the AMD fobos modes):
! the OpenMP-offload backend (DEV_OMP) does not expose device memory status, so
! the HIP runtime is used to fill that gap. These symbols live in libamdhip64,
! which is not available on the Intel stack, hence the DEV_HIP guard.
interface
   function hipMemGetInfo(free, total) result(ierr) bind(c, name='hipMemGetInfo')
   !< Query free and total memory of the current HIP device [bytes].
   import :: C_INT, C_SIZE_T
   integer(C_SIZE_T), intent(out) :: free  !< Free device memory [bytes].
   integer(C_SIZE_T), intent(out) :: total !< Total device memory [bytes].
   integer(C_INT)                 :: ierr  !< HIP error code (0 on success).
   endfunction hipMemGetInfo

   function hipSetDevice(device) result(ierr) bind(c, name='hipSetDevice')
   !< Set the current HIP device.
   import :: C_INT
   integer(C_INT), value :: device !< Device ID.
   integer(C_INT)        :: ierr   !< HIP error code (0 on success).
   endfunction hipSetDevice

   function hipDeviceGetName(name, len, device) result(ierr) bind(c, name='hipDeviceGetName')
   !< Return the (null-terminated) name of the given HIP device.
   import :: C_CHAR, C_INT
   character(kind=C_CHAR), intent(out) :: name(*) !< Device name buffer.
   integer(C_INT), value               :: len    !< Buffer length.
   integer(C_INT), value               :: device !< Device ID.
   integer(C_INT)                      :: ierr   !< HIP error code (0 on success).
   endfunction hipDeviceGetName

   function hipDeviceComputeCapability(major, minor, device) result(ierr) bind(c, name='hipDeviceComputeCapability')
   !< Return the compute capability (major.minor) of the given HIP device.
   import :: C_INT
   integer(C_INT), intent(out) :: major  !< Compute capability major number.
   integer(C_INT), intent(out) :: minor  !< Compute capability minor number.
   integer(C_INT), value       :: device !< Device ID.
   integer(C_INT)              :: ierr   !< HIP error code (0 on success).
   endfunction hipDeviceComputeCapability

   function hipDriverGetVersion(version) result(ierr) bind(c, name='hipDriverGetVersion')
   !< Return the installed HIP driver version.
   import :: C_INT
   integer(C_INT), intent(out) :: version !< Driver version.
   integer(C_INT)              :: ierr    !< HIP error code (0 on success).
   endfunction hipDriverGetVersion
endinterface
#endif

contains
#if defined DEV_OAC
   subroutine dev_get_device_memory_info(mem_free, mem_total)
   !< Get the current device memory status.
   !< @NOTE Currently implemented only OpenACC backend.
   integer(I8P), intent(out), optional :: mem_free  !< Free memory.
   integer(I8P), intent(out), optional :: mem_total !< Total memory.
   integer(C_SIZE_T)                   :: mem       !< C buffer.

   if (present(mem_free)) then
      mem = acc_get_property(mydev, devtype, ACC_PROPERTY_FREE_MEMORY)
      mem_free = int(mem,I8P)
   endif
   if (present(mem_total)) then
      mem = acc_get_property(mydev, devtype, ACC_PROPERTY_MEMORY)
      mem_total = int(mem,I8P)
   endif
   endsubroutine dev_get_device_memory_info

   function dev_get_device_num() result(device_num)
   !< Return the value of current device ID for the current thread.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer(I4P) :: device_num !< Device ID for current thread.

   device_num = acc_get_device_num(devtype)
   endfunction dev_get_device_num

   function dev_get_host_num() result(host_num)
   !< Return the value of current host ID for the current thread.
   integer(I4P) :: host_num !< Device ID for current thread.

   host_num = acc_get_device_num(ACC_DEVICE_HOST)
   endfunction dev_get_host_num

   function dev_get_num_devices() result(devices_number)
   !< Return the number of available (non host) devices.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer(I4P) :: devices_number !< Devices number.

   devices_number = acc_get_num_devices(devtype)
   endfunction dev_get_num_devices

   subroutine dev_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer, value,                  intent(in)            :: dev_num  !< Device ID.
   character(*),                    intent(out)           :: string   !< Stringified device property.
   character(*),                    intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),                    intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                              :: prefix_  !< String prefix, local var.
   character(99)                                          :: string_  !< Local string buffer.
   integer(I8P)                                           :: memory_  !< Device memory, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = ''
   memory_ = acc_get_property(dev_num, devtype, ACC_PROPERTY_MEMORY)
   write(string_,'(I16)') memory_
   if (present(memory)) memory = memory_
   string = trim(string)//prefix_//'memory     : '//trim(adjustl(string_))//new_line('a')
   memory_ = acc_get_property(dev_num, devtype, ACC_PROPERTY_FREE_MEMORY)
   write(string_,'(I16)') memory_
   string = trim(string)//prefix_//'memory free: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, devtype, ACC_PROPERTY_NAME, string_)
   string = trim(string)//prefix_//'device name: '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, devtype, ACC_PROPERTY_VENDOR, string_)
   string = trim(string)//prefix_//'vendor     : '//trim(adjustl(string_))//new_line('a')
   call acc_get_property_string(dev_num, devtype, ACC_PROPERTY_DRIVER, string_)
   string = trim(string)//prefix_//'driver     : '//trim(adjustl(string_))
   endsubroutine dev_get_property_string

   subroutine dev_init(local_rank)
   !< Initialize device.
   integer(I4P), intent(in), optional :: local_rank !< Local rank in multi-processes split ID.

   devtype = dev_get_device_type()
   call acc_init(devtype)
   devs_number = dev_get_num_devices()
   if (present(local_rank)) then
      mydev = mod(local_rank, devs_number)
   else
      mydev = 0
   endif
   myhos = dev_get_host_num()
   call dev_set_device_num(mydev)
   call dev_get_device_memory_info(dev_memory_avail)
   endsubroutine dev_init

   subroutine dev_set_device_num(dev_num)
   !< Set the runtime for the specified device type and device number.
   !< Note: the device type environment global variable, devtype, must be set before use this routine. By default it is seto to
   !< acc_device_default.
   integer, value, intent(in) :: dev_num !< Device ID.

   call acc_set_device_num(dev_num, devtype)
   endsubroutine dev_set_device_num
#elif defined DEV_OMP
   subroutine dev_get_device_memory_info(mem_free, mem_total)
   !< Get the current device memory status.
   !< @NOTE OpenMP offload does not expose device memory status: on AMD/ROCm builds (DEV_HIP) the HIP runtime is queried,
   !< otherwise (e.g. Intel IFX) zeros are returned.
   integer(I8P), intent(out), optional :: mem_free  !< Free memory.
   integer(I8P), intent(out), optional :: mem_total !< Total memory.
#if defined DEV_HIP
   integer(C_SIZE_T)                   :: hip_free  !< Free device memory [bytes].
   integer(C_SIZE_T)                   :: hip_total !< Total device memory [bytes].
   integer(C_INT)                      :: ierr      !< HIP error code.

   ierr = hipSetDevice(int(mydev, C_INT))
   ierr = hipMemGetInfo(hip_free, hip_total)
   if (present(mem_free))  mem_free  = int(hip_free,  I8P)
   if (present(mem_total)) mem_total = int(hip_total, I8P)
#else
   if (present(mem_free)) then
      mem_free = 0_I8P
   endif
   if (present(mem_total)) then
      mem_total = 0_I8P
   endif
#endif
   endsubroutine dev_get_device_memory_info

   function dev_get_device_type() result(devtype_)
   !< Return the device type.
   !< OpenMP has no device-type/vendor enum, but it does expose whether the default device is the host (initial) device or
   !< an actual offload device: this is used to discriminate FUNDAL_DEVICE_HOST from FUNDAL_DEVICE_GPU.
   integer(I4P) :: devtype_ !< Device type.

   if (dev_get_num_devices() < 1 .or. dev_get_device_num() == dev_get_host_num()) then
      devtype_ = FUNDAL_DEVICE_HOST
   else
      devtype_ = FUNDAL_DEVICE_GPU
   endif
   endfunction dev_get_device_type

   subroutine dev_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< @NOTE OpenMP offload does not expose device properties: on AMD/ROCm builds (DEV_HIP) the HIP runtime is queried,
   !< otherwise (e.g. Intel IFX) an empty string is returned (added only for seamless unified API).
   integer, value,      intent(in)            :: dev_num  !< Device ID.
   character(*),        intent(out)           :: string   !< Stringified device property.
   character(*),        intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),        intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                  :: prefix_  !< String prefix, local var.
#if defined DEV_HIP
   character(kind=C_CHAR)                     :: hip_name(256) !< Device name buffer (C).
   character(256)                             :: hip_namef     !< Device name buffer (Fortran).
   character(99)                              :: hip_string    !< Local string buffer.
   integer(C_SIZE_T)                          :: hip_free      !< Free device memory [bytes].
   integer(C_SIZE_T)                          :: hip_total     !< Total device memory [bytes].
   integer(C_INT)                             :: cc_major      !< Compute capability major number.
   integer(C_INT)                             :: cc_minor      !< Compute capability minor number.
   integer(C_INT)                             :: driver_ver    !< HIP driver version.
   integer(C_INT)                             :: ierr          !< HIP error code.
   integer(I4P)                               :: c             !< Counter.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = ''
   ierr = hipSetDevice(int(dev_num, C_INT))
   ierr = hipMemGetInfo(hip_free, hip_total)
   write(hip_string,'(I16)') int(hip_total, I8P)
   if (present(memory)) memory = int(hip_total, I8P)
   string = trim(string)//prefix_//'memory     : '//trim(adjustl(hip_string))//new_line('a')
   write(hip_string,'(I16)') int(hip_free, I8P)
   string = trim(string)//prefix_//'memory free: '//trim(adjustl(hip_string))//new_line('a')
   ierr = hipDeviceGetName(hip_name, int(size(hip_name), C_INT), int(dev_num, C_INT))
   hip_namef = ''
   do c=1, size(hip_name)
      if (hip_name(c) == C_NULL_CHAR) exit
      hip_namef(c:c) = hip_name(c)
   enddo
   string = trim(string)//prefix_//'device name: '//trim(adjustl(hip_namef))//new_line('a')
   ierr = hipDeviceComputeCapability(cc_major, cc_minor, int(dev_num, C_INT))
   write(hip_string,'(I0,".",I0)') cc_major, cc_minor
   string = trim(string)//prefix_//'compute cap: '//trim(adjustl(hip_string))//new_line('a')
   ierr = hipDriverGetVersion(driver_ver)
   write(hip_string,'(I0)') driver_ver
   string = trim(string)//prefix_//'driver     : '//trim(adjustl(hip_string))
#else
   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = prefix_
   if (present(memory)) memory = 0_I8P
#endif
   endsubroutine dev_get_property_string

   subroutine dev_init(local_rank)
   !< Initialize device.
   integer(I4P), intent(in), optional :: local_rank !< Local rank in multi-processes split ID.

   devs_number = dev_get_num_devices()
   if (present(local_rank)) then
      mydev = mod(local_rank, devs_number)
   else
      mydev = dev_get_device_num()
   endif
   myhos = dev_get_host_num()
   call dev_set_device_num(mydev)
   call dev_get_device_memory_info(dev_memory_avail)
   endsubroutine dev_init
#else
   subroutine dev_get_device_memory_info(mem_free, mem_total)
   !< Get the current device memory status.
   !< @NOTE Currently implemented only OpenACC backend.
   integer(I8P), intent(out), optional :: mem_free  !< Free memory.
   integer(I8P), intent(out), optional :: mem_total !< Total memory.

   if (present(mem_free)) then
      mem_free = 0_I8P
   endif
   if (present(mem_total)) then
      mem_total = 0_I8P
   endif
   endsubroutine dev_get_device_memory_info

   function dev_get_device_num() result(device_num)
   !< Return the value of current device ID for the current thread.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: device_num !< Device ID for current thread.

   device_num = 0_I4P
   endfunction dev_get_device_num

   function dev_get_device_type() result(devtype_)
   !< Return the device type.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: devtype_ !< Device type.

   devtype_ = 0_I4P
   endfunction dev_get_device_type

   function dev_get_host_num() result(host_num)
   !< Return the value of current host ID for the current thread.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: host_num !< Device ID for current thread.

   host_num = 0_I4P
   endfunction dev_get_host_num

   function dev_get_num_devices() result(devices_number)
   !< Return the number of available (non host) devices.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer(I4P) :: devices_number !< Devices number.

   devices_number = 1_I4P
   endfunction dev_get_num_devices

   subroutine dev_get_property_string(dev_num, string, prefix, memory)
   !< Return the value of a device-property for the specified device.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer, value,      intent(in)            :: dev_num  !< Device ID.
   character(*),        intent(out)           :: string   !< Stringified device property.
   character(*),        intent(in),  optional :: prefix   !< String prefix.
   integer(I8P),        intent(out), optional :: memory   !< Device memory.
   character(:), allocatable                  :: prefix_  !< String prefix, local var.

   prefix_ = '' ; if (present(prefix)) prefix_ = prefix
   string = prefix_
   if (present(memory)) memory = 0_I8P
   endsubroutine dev_get_property_string

   subroutine dev_set_device_num(dev_num)
   !< Set the runtime for the specified device type and device number.
   !< Note: host fallback does not provide such a runtime routine, added only for seamless unified API.
   integer, value, intent(in) :: dev_num !< Device ID.
   endsubroutine dev_set_device_num

   subroutine dev_init()
   !< Initialize device.
   !< Note: backsafe backend does nothing, obviously.
   endsubroutine dev_init
#endif
endmodule fundal_dev_handling
