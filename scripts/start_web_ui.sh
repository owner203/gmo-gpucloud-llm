#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=${1:-$HOME/gmo-gpucloud-llm}
port=${2:-8888}
lang=${3:-'en'}

source $work_dir/scripts/activate_env.sh $work_dir

export NCCL_P2P_DISABLE=0
export NCCL_P2P_LEVEL=NVL
export NCCL_SOCKET_FAMILY=AF_INET
export NCCL_SOCKET_NTHREADS=16
export NCCL_NSOCKS_PERTHREAD=4
export NCCL_IB_DISABLE=1
export NCCL_NET_GDR_LEVEL=PIX
export NCCL_NET_GDR_READ=1
export NCCL_DEBUG=INFO

export DATASET_ENABLE_CACHE=1
export OMP_NUM_THREADS=$(($(nproc) / 16))

swift web-ui \
    --host $(hostname) \
    --port $port \
    --lang $lang \
    --share False
