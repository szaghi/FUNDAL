!< FUNDAL, allocation registry module: device and size of every structured allocation.

#include "fundal.H"

module fundal_registry
!< FUNDAL, allocation registry module: device and size of every structured allocation.
!<
!< Host-side open-addressing hash table (linear probing, backward-shift deletion, doubling at load 0.5) keyed by the base
!< address of the buffer; key 0 marks an empty slot (a successful allocation never returns a null address). The registry
!< owns the live-allocation totals and mirrors them into the fundal_env counters (dev_allocs_live, dev_bytes_live).
!< A second structure, the base addresses sorted in ascending order, finds the allocation containing an address (a section
!< of a buffer) by binary search: O(log n) lookup, O(n) insertion and removal.
!< Updates are serialized by an OpenMP critical section: thread-safe only when the library is compiled with OpenMP.
use, intrinsic :: iso_c_binding,   only : c_intptr_t, c_ptr
use, intrinsic :: iso_fortran_env, only : I4P=>int32, I8P=>int64, output_unit, error_unit
use            :: fundal_env,      only : dev_allocs_live, dev_bytes_live, FUNDAL_ERR_NOT_REGISTERED, &
                                          FUNDAL_ERR_DEV_ID_MISMATCH

implicit none
private
public :: registry_entry
public :: registry_address
public :: registry_insert
public :: registry_remove
public :: registry_lookup
public :: registry_lookup_range
public :: registry_stats
public :: registry_report
public :: registry_clear
public :: registry_policy
public :: registry_misuse
public :: dev_set_registry_policy
public :: FUNDAL_REGISTRY_OFF, FUNDAL_REGISTRY_WARN, FUNDAL_REGISTRY_ERROR
public :: FUNDAL_ERR_NOT_REGISTERED, FUNDAL_ERR_DEV_ID_MISMATCH

integer(I4P), parameter :: FUNDAL_REGISTRY_OFF   = 0_I4P !< Registry checks disabled: today's behaviour, no warnings.
integer(I4P), parameter :: FUNDAL_REGISTRY_WARN  = 1_I4P !< Misuse is reported on stderr, behaviour unchanged (default).
integer(I4P), parameter :: FUNDAL_REGISTRY_ERROR = 2_I4P !< Misuse is an error (error code or error stop).


integer(I4P), parameter :: LABEL_LEN        = 32_I4P     !< Length of allocation labels.
integer(I8P), parameter :: INITIAL_CAPACITY = 64_I8P     !< Initial number of slots (power of 2).

type :: registry_entry
   !< Registered allocation.
   integer(c_intptr_t)  :: addr=0_c_intptr_t !< Base address of the buffer (0 = empty slot).
   integer(I8P)         :: bytes=0_I8P       !< Size of the buffer [bytes].
   integer(I4P)         :: dev_id=0_I4P      !< Device where the buffer lives.
   character(LABEL_LEN) :: label=''          !< Optional user label.
endtype registry_entry

type(registry_entry), allocatable, save :: table(:)       !< Hash table, slots 0:capacity-1.
integer(c_intptr_t),  allocatable, save :: sorted(:)      !< Base addresses in ascending order, sorted(1:used).
integer(I8P),                      save :: used=0_I8P     !< Number of occupied slots.
integer(I4P),                      save :: policy_=-1_I4P !< Registry policy, -1 = not yet resolved.

contains
   ! public procedures
   function registry_address(cptr) result(addr)
   !< Return the address held by a C pointer as an integer key.
   type(c_ptr), intent(in) :: cptr !< C pointer.
   integer(c_intptr_t)     :: addr !< Address.

   addr = transfer(cptr, addr)
   endfunction registry_address

   subroutine registry_insert(addr, bytes, dev_id, label, replaced)
   !< Register an allocation. If the address is already registered (its buffer was released outside FUNDAL and the
   !< address reused), the old entry is replaced and replaced is set to true.
   integer(c_intptr_t), intent(in)            :: addr     !< Base address.
   integer(I8P),        intent(in)            :: bytes    !< Size [bytes].
   integer(I4P),        intent(in)            :: dev_id   !< Device.
   character(*),        intent(in),  optional :: label    !< Label.
   logical,             intent(out), optional :: replaced !< Address was already registered.
   integer(I8P)                               :: slot     !< Slot of the address.
   logical                                    :: found    !< Address already registered.

   if (present(replaced)) replaced = .false.
   if (addr == 0_c_intptr_t) return
   !$omp critical (fundal_registry)
   if (.not.allocated(table)) call table_init(INITIAL_CAPACITY)
   if (2_I8P * (used + 1_I8P) > size(table, kind=I8P)) call table_resize(2_I8P * size(table, kind=I8P))
   call table_find(addr, slot, found)
   if (found) then
      call totals_update(-1_I8P, -table(slot)%bytes)
   else
      call sorted_insert(addr)
      used = used + 1_I8P
   endif
   table(slot)%addr   = addr
   table(slot)%bytes  = bytes
   table(slot)%dev_id = dev_id
   table(slot)%label  = ''
   if (present(label)) table(slot)%label = label
   call totals_update(1_I8P, bytes)
   !$omp end critical (fundal_registry)
   if (present(replaced)) replaced = found
   endsubroutine registry_insert

   subroutine registry_remove(addr, found, entry)
   !< Unregister an allocation, returning its entry.
   integer(c_intptr_t),  intent(in)            :: addr  !< Base address.
   logical,              intent(out)           :: found !< Address was registered.
   type(registry_entry), intent(out), optional :: entry !< Removed entry.
   integer(I8P)                                :: slot  !< Slot of the address.

   found = .false.
   !$omp critical (fundal_registry)
   if (allocated(table) .and. addr /= 0_c_intptr_t) then
      call table_find(addr, slot, found)
      if (found) then
         if (present(entry)) entry = table(slot)
         call totals_update(-1_I8P, -table(slot)%bytes)
         call table_delete(slot)
         call sorted_remove(addr)
         used = used - 1_I8P
      endif
   endif
   !$omp end critical (fundal_registry)
   endsubroutine registry_remove

   subroutine registry_lookup(addr, found, entry)
   !< Look an allocation up.
   integer(c_intptr_t),  intent(in)            :: addr  !< Base address.
   logical,              intent(out)           :: found !< Address is registered.
   type(registry_entry), intent(out), optional :: entry !< Entry.
   integer(I8P)                                :: slot  !< Slot of the address.

   found = .false.
   !$omp critical (fundal_registry)
   if (allocated(table) .and. addr /= 0_c_intptr_t) then
      call table_find(addr, slot, found)
      if (found .and. present(entry)) entry = table(slot)
   endif
   !$omp end critical (fundal_registry)
   endsubroutine registry_lookup

   subroutine registry_lookup_range(addr, bytes, found, entry, overflow)
   !< Look up the allocation containing the range [addr, addr+bytes): the whole buffer (exact hash lookup) or a part of it
   !< (binary search of the sorted base addresses). A range that starts inside an allocation but ends beyond it is not
   !< found and sets overflow.
   integer(c_intptr_t),  intent(in)            :: addr     !< Start address of the range.
   integer(I8P),         intent(in)            :: bytes    !< Size of the range [bytes].
   logical,              intent(out)           :: found    !< The range lies inside a registered allocation.
   type(registry_entry), intent(out), optional :: entry    !< Entry of the containing allocation.
   logical,              intent(out), optional :: overflow !< The range starts inside an allocation but ends beyond it.
   type(registry_entry)                        :: entry_   !< Containing allocation, local var.
   logical                                     :: inside   !< The start address lies inside an allocation.
   integer(I8P)                                :: slot     !< Slot of the base address.
   integer(I8P)                                :: pos      !< Position in the sorted base addresses.

   found = .false.
   inside = .false.
   !$omp critical (fundal_registry)
   if (allocated(table) .and. addr /= 0_c_intptr_t) then
      call table_find(addr, slot, inside)
      if (.not.inside) then
         pos = sorted_position(addr) - 1_I8P ! last base address <= addr (addr itself is not a base address)
         if (pos >= 1_I8P) then
            call table_find(sorted(pos), slot, inside)
            if (inside) inside = (addr - table(slot)%addr < table(slot)%bytes)
         endif
      endif
      if (inside) then
         entry_ = table(slot)
         found = (addr - entry_%addr + bytes <= entry_%bytes)
      endif
   endif
   !$omp end critical (fundal_registry)
   if (present(entry) .and. found) entry = entry_
   if (present(overflow)) overflow = inside .and. (.not.found)
   endsubroutine registry_lookup_range

   subroutine registry_stats(allocs, bytes, dev_id)
   !< Return the number and the bytes of live allocations, optionally only those on one device.
   integer(I8P), intent(out), optional :: allocs !< Number of live allocations.
   integer(I8P), intent(out), optional :: bytes  !< Bytes of live allocations.
   integer(I4P), intent(in),  optional :: dev_id !< Count only allocations on this device.
   integer(I8P)                        :: n, b   !< Accumulators.
   integer(I8P)                        :: s      !< Slot counter.

   !$omp critical (fundal_registry)
   if (.not.present(dev_id)) then
      n = dev_allocs_live ; b = dev_bytes_live
   else
      n = 0_I8P ; b = 0_I8P
      if (allocated(table)) then
         do s=0_I8P, size(table, kind=I8P) - 1_I8P
            if (table(s)%addr /= 0_c_intptr_t .and. table(s)%dev_id == dev_id) then
               n = n + 1_I8P ; b = b + table(s)%bytes
            endif
         enddo
      endif
   endif
   !$omp end critical (fundal_registry)
   if (present(allocs)) allocs = n
   if (present(bytes)) bytes = b
   endsubroutine registry_stats

   subroutine registry_report(unit)
   !< Write the live allocations (address, bytes, device, label), one per line in ascending address order, followed by a
   !< summary line.
   integer(I4P), intent(in), optional :: unit  !< Output unit (default standard output).
   integer(I4P)                       :: unit_ !< Output unit, local var.
   integer(I8P)                       :: k     !< Counter of the sorted base addresses.
   integer(I8P)                       :: s     !< Slot of an address.
   logical                            :: found !< Address present (always, the structures agree).

   unit_ = output_unit ; if (present(unit)) unit_ = unit
   !$omp critical (fundal_registry)
   if (allocated(table)) then
      do k=1_I8P, used
         call table_find(sorted(k), s, found)
         write(unit_, '(A,Z16.16,A,I0,A,I0,A)') 'FUNDAL live allocation: address=0x', table(s)%addr, &
            ' bytes=', table(s)%bytes, ' device=', table(s)%dev_id, ' label="'//trim(table(s)%label)//'"'
      enddo
   endif
   write(unit_, '(A,I0,A,I0,A)') 'FUNDAL live allocations: ', dev_allocs_live, ' (', dev_bytes_live, ' bytes)'
   !$omp end critical (fundal_registry)
   endsubroutine registry_report

   subroutine registry_clear()
   !< Forget every allocation (without freeing any memory) and reset the totals. Meant for tests.

   !$omp critical (fundal_registry)
   if (allocated(table)) deallocate(table)
   if (allocated(sorted)) deallocate(sorted)
   used = 0_I8P
   dev_allocs_live = 0_I8P
   dev_bytes_live = 0_I8P
   !$omp end critical (fundal_registry)
   endsubroutine registry_clear

   function registry_policy() result(policy)
   !< Return the registry policy; on first use it is read from the environment variable FUNDAL_REGISTRY
   !< (off, warn or error; default warn) unless already set by dev_set_registry_policy.
   integer(I4P)  :: policy !< Registry policy.
   character(16) :: val    !< Environment value.
   integer(I4P)  :: status !< Query status.

   if (policy_ < 0_I4P) then
      policy_ = FUNDAL_REGISTRY_WARN
      call get_environment_variable('FUNDAL_REGISTRY', value=val, status=status)
      if (status == 0) call set_policy(val)
   endif
   policy = policy_
   endfunction registry_policy

   subroutine dev_set_registry_policy(policy, ierr)
   !< Set the registry policy: 'off', 'warn' or 'error' (case insensitive). It overrides FUNDAL_REGISTRY.
   character(*), intent(in)            :: policy  !< Policy name.
   integer(I4P), intent(out), optional :: ierr    !< Error status: 1 if the name is not valid (policy unchanged).
   integer(I4P)                        :: current !< Current policy (resolves the environment default first).
   logical                             :: valid   !< Valid policy name.

   current = registry_policy()
   call set_policy(policy, valid)
   if (present(ierr)) then
      ierr = 0_I4P ; if (.not.valid) ierr = 1_I4P
   endif
   endsubroutine dev_set_registry_policy

   subroutine registry_misuse(msg, action)
   !< Report a misuse according to the policy: error stop with policy error, warning on stderr with policy warn (followed
   !< by the action taken, the caller then proceeds), nothing with policy off.
   character(*), intent(in) :: msg    !< Description of the misuse.
   character(*), intent(in) :: action !< What is done anyway under policy warn.

   select case(registry_policy())
   case(FUNDAL_REGISTRY_ERROR)
      write(error_unit, '(A)') 'FUNDAL error: '//msg
      error stop 'FUNDAL: allocation registry misuse'
   case(FUNDAL_REGISTRY_WARN)
      write(error_unit, '(A)') 'FUNDAL warning: '//msg//', '//action
   endselect
   endsubroutine registry_misuse

   ! private procedures
   subroutine set_policy(name, valid)
   !< Set the policy from its name, leaving it unchanged if the name is not valid.
   character(*), intent(in)            :: name   !< Policy name.
   logical,      intent(out), optional :: valid  !< Valid name.
   character(len(name))                :: upper  !< Upper case name.
   integer(I4P)                        :: c      !< Counter.
   logical                             :: valid_ !< Valid name, local var.

   upper = adjustl(name)
   do c=1, len(upper)
      if (upper(c:c) >= 'a' .and. upper(c:c) <= 'z') upper(c:c) = achar(iachar(upper(c:c)) - 32)
   enddo
   valid_ = .true.
   select case(trim(upper))
   case('OFF')
      policy_ = FUNDAL_REGISTRY_OFF
   case('WARN')
      policy_ = FUNDAL_REGISTRY_WARN
   case('ERROR')
      policy_ = FUNDAL_REGISTRY_ERROR
   case default
      valid_ = .false.
   endselect
   if (present(valid)) valid = valid_
   endsubroutine set_policy

   subroutine totals_update(dn, db)
   !< Update the live totals (mirrored in fundal_env).
   integer(I8P), intent(in) :: dn !< Allocations increment.
   integer(I8P), intent(in) :: db !< Bytes increment.

   dev_allocs_live = dev_allocs_live + dn
   dev_bytes_live = dev_bytes_live + db
   endsubroutine totals_update

   pure function home_slot(addr, capacity) result(slot)
   !< Return the home slot of an address: shift-xor mixing (no multiplication, so no integer overflow) of the address,
   !< whose low bits are zero for aligned device buffers, reduced modulo the power-of-2 capacity.
   integer(c_intptr_t), intent(in) :: addr     !< Address.
   integer(I8P),        intent(in) :: capacity !< Number of slots (power of 2).
   integer(I8P)                    :: slot     !< Home slot.
   integer(I8P)                    :: h        !< Hash.

   h = int(addr, I8P)
   h = ieor(h, ishft(h, -17))
   h = ieor(h, ishft(h, -9))
   h = ieor(h, ishft(h, -5))
   slot = modulo(h, capacity)
   endfunction home_slot

   pure function sorted_position(addr) result(pos)
   !< Return the position of the first sorted base address >= addr (used + 1 if none), by binary search.
   integer(c_intptr_t), intent(in) :: addr   !< Address.
   integer(I8P)                    :: pos    !< Position.
   integer(I8P)                    :: hi, mi !< Search bounds.

   pos = 1_I8P
   hi = used + 1_I8P
   do while (pos < hi)
      mi = pos + (hi - pos) / 2_I8P
      if (sorted(mi) < addr) then
         pos = mi + 1_I8P
      else
         hi = mi
      endif
   enddo
   endfunction sorted_position

   subroutine sorted_insert(addr)
   !< Insert a new base address in the sorted list (called before used is incremented).
   integer(c_intptr_t), intent(in)  :: addr   !< Address.
   integer(c_intptr_t), allocatable :: old(:) !< Old list.
   integer(I8P)                     :: pos    !< Insertion position.

   if (.not.allocated(sorted)) allocate(sorted(INITIAL_CAPACITY))
   if (used + 1_I8P > size(sorted, kind=I8P)) then
      call move_alloc(sorted, old)
      allocate(sorted(2_I8P * size(old, kind=I8P)))
      sorted(1:used) = old(1:used)
   endif
   pos = sorted_position(addr)
   sorted(pos+1_I8P:used+1_I8P) = sorted(pos:used)
   sorted(pos) = addr
   endsubroutine sorted_insert

   subroutine sorted_remove(addr)
   !< Remove a base address from the sorted list (called before used is decremented).
   integer(c_intptr_t), intent(in) :: addr !< Address.
   integer(I8P)                    :: pos  !< Position.

   pos = sorted_position(addr)
   if (pos > used) return
   if (sorted(pos) /= addr) return
   sorted(pos:used-1_I8P) = sorted(pos+1_I8P:used)
   endsubroutine sorted_remove

   subroutine table_init(capacity)
   !< Allocate an empty table.
   integer(I8P), intent(in) :: capacity !< Number of slots (power of 2).

   allocate(table(0:capacity-1_I8P))
   used = 0_I8P
   endsubroutine table_init

   subroutine table_find(addr, slot, found)
   !< Find the slot of an address, or the empty slot where it would be inserted.
   integer(c_intptr_t), intent(in)  :: addr     !< Address.
   integer(I8P),        intent(out) :: slot     !< Slot.
   logical,             intent(out) :: found    !< Address present.
   integer(I8P)                     :: capacity !< Number of slots.

   capacity = size(table, kind=I8P)
   slot = home_slot(addr, capacity)
   found = .false.
   do
      if (table(slot)%addr == 0_c_intptr_t) exit
      if (table(slot)%addr == addr) then
         found = .true.
         exit
      endif
      slot = modulo(slot + 1_I8P, capacity)
   enddo
   endsubroutine table_find

   subroutine table_delete(slot)
   !< Empty a slot with backward-shift deletion, so that no tombstones are needed: entries of the following cluster that
   !< may move closer to their home slot are shifted into the hole.
   integer(I8P), intent(in) :: slot     !< Slot to empty.
   integer(I8P)             :: hole     !< Current hole.
   integer(I8P)             :: j        !< Probe slot.
   integer(I8P)             :: home     !< Home slot of the entry in j.
   integer(I8P)             :: capacity !< Number of slots.

   capacity = size(table, kind=I8P)
   hole = slot
   j = slot
   do
      j = modulo(j + 1_I8P, capacity)
      if (table(j)%addr == 0_c_intptr_t) exit
      home = home_slot(table(j)%addr, capacity)
      ! the entry in j may fill the hole unless its home is (cyclically) in (hole, j]
      if (modulo(j - home, capacity) >= modulo(j - hole, capacity)) then
         table(hole) = table(j)
         hole = j
      endif
   enddo
   table(hole) = registry_entry()
   endsubroutine table_delete

   subroutine table_resize(capacity)
   !< Rehash every entry into a table of the given capacity.
   integer(I8P), intent(in)          :: capacity !< New number of slots (power of 2).
   type(registry_entry), allocatable :: old(:)   !< Old table.
   integer(I8P)                      :: s        !< Slot counter.
   integer(I8P)                      :: slot     !< Slot in the new table.
   logical                           :: found    !< Address present (never, keys are unique).

   call move_alloc(table, old)
   call table_init(capacity)
   do s=lbound(old, dim=1, kind=I8P), ubound(old, dim=1, kind=I8P)
      if (old(s)%addr /= 0_c_intptr_t) then
         call table_find(old(s)%addr, slot, found)
         table(slot) = old(s)
         used = used + 1_I8P
      endif
   enddo
   endsubroutine table_resize
endmodule fundal_registry
