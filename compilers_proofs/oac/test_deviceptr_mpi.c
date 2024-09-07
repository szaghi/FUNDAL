#include <mpi.h>
#include "openacc.h"
#include "mpi-ext.h" /* Needed for CUDA-aware check */

int main(int argc, char* argv[])
{
  MPI_Init(&argc, &argv);

  if (1 == MPIX_Query_cuda_support()) {
      printf("This MPI library has CUDA-aware support.\n");
  } else {
      printf("This MPI library does not have CUDA-aware support.\n");
  }

  int rank = -1;
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  //printf("rank=%d\n", rank);

  int ngpus = acc_get_num_devices(acc_device_nvidia);
  int devicenum = (rank)%(ngpus);
  //printf("devicenum=%d\n", devicenum);

  acc_set_device_num(devicenum,acc_device_nvidia);
  acc_init(acc_device_nvidia);

  //int buffer[10];
  int *buffer = acc_malloc((size_t)10*sizeof(int));
  if (rank == 0) {
    #pragma acc parallel loop deviceptr(buffer)
    for (int i=0; i<10; i++) buffer[i] = i;
  }

  if (rank == 0) {
    MPI_Send(buffer, 10, MPI_INT, 1, 0, MPI_COMM_WORLD);
  }
  else {
    MPI_Recv(buffer, 10, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
#pragma acc serial deviceptr(buffer)
{
    printf("rank=1, %d\n", buffer[2]);
}
  }
  acc_free(buffer);

  MPI_Finalize();
}
