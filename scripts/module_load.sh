#!/bin/bash

module load cmake/3.30.5
module load cuda/12.4.1
module load cudnn/9.5.0.50_cuda12
module load gcc/13.3.0
module load gdrcopy/2.4.1-cuda-12.4
module load hpcx/v2.18.1-cuda12
module load hpcx-prof/v2.18.1-cuda12
module load nccl/2.21.5-1-cuda-12.4
module load python/3.11.10

export LD_LIBRARY_PATH=/opt/share/modules/spack/v24.09/linux-ubuntu22.04-x86_64_v4/gcc-11.4.0/gcc-13.3.0-cago4jnrborkiq5whh7fnng7w3epao7k/lib64
export NCCL_LIB_DIR=/opt/share/modules/spack/v24.09/linux-ubuntu22.04-x86_64_v4/gcc-11.4.0/nccl-2.21.5-1-4gaygcfzk6l7jw34v5asjz7mdy2yngoj/lib
export NCCL_INCLUDE_DIR=/opt/share/modules/spack/v24.09/linux-ubuntu22.04-x86_64_v4/gcc-11.4.0/nccl-2.21.5-1-4gaygcfzk6l7jw34v5asjz7mdy2yngoj/include
export USE_SYSTEM_NCCL=1
export TORCH_EXTENSIONS_DIR=/scratch/torch-extensions

echo "Modules loaded on $(hostname)"
