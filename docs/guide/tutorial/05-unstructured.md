---
title: 5. The unstructured model
---

# 5. The unstructured model

So far the temperature lived only on the device. When the host also works on an array (input, output, a part of the
code not yet ported), the **unstructured model** gives an existing host array a copy on the device:

<<< @/examples/snippets/heat_5-map.F90{fortran}

`dev_alloc_unstr` creates the device copy without setting it, unless `init_value` is passed (the value is then set on
the device, not on the host); `dev_memcpy_to_device_unstr` copies the host values into it. The kernels name the host
arrays themselves: OpenACC finds their device copies with `present`, OpenMP needs no clause because they are already
mapped. With allocatables there is no pointer to swap, so each iteration makes two steps:

<<< @/examples/snippets/heat_5-step.F90{fortran}

At the end the device copy goes back to the host, and the mapping is released (the host arrays stay allocated):

<<< @/examples/snippets/heat_5-unmap.F90{fortran}

<<< @/examples/output/heat_5.txt{text}

::: warning Two copies of the same array
After `dev_alloc_unstr` the host and the device copies are independent: a kernel changes only the device copy, a host
assignment only the host copy, until `dev_memcpy_to_device_unstr` or `dev_memcpy_from_device_unstr` copies one onto the
other. In a host run the two copies are the same memory, so a missing copy goes unnoticed: test on a device. Do not
deallocate the host array before `dev_free_unstr`.
:::

::: tip What you learned
`dev_alloc_unstr`, `dev_memcpy_to_device_unstr`, `dev_memcpy_from_device_unstr`, `dev_free_unstr`; `present` for mapped
arrays; when to prefer each model ([Concepts](/guide/concepts#two-memory-models)).
Reference: [Unstructured memory](/reference/unstructured).
:::

Next: [6. Several devices with MPI](./06-mpi).
