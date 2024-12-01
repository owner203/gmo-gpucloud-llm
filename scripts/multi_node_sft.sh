#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=${1:-$HOME/gmo-gpucloud-llm}
model_type=$2
model_id_or_path=$3
template_type=$4
dataset=$5
max_length=$6
lazy_tokenize=$7
batch_size=$8
ds_config=$9

if [ "$ds_config" != "None" ]; then
  deepspeed_arg="--deepspeed $ds_config"
else
  deepspeed_arg=""
fi

source $work_dir/scripts/module_load.sh

source $work_dir/.venv/bin/activate

if [ "$SLURM_NNODES" -eq 1 ]; then
  export NCCL_P2P_DISABLE=0
  export NCCL_P2P_LEVEL=NVL
elif [ "$SLURM_NNODES" -eq 2 ]; then
  export NCCL_P2P_DISABLE=0
else
  export NCCL_P2P_DISABLE=1
fi

export NCCL_SOCKET_FAMILY=AF_INET
export NCCL_SOCKET_NTHREADS=16
export NCCL_NSOCKS_PERTHREAD=4
export NCCL_IB_DISABLE=1
export NCCL_NET_GDR_LEVEL=PIX
export NCCL_NET_GDR_READ=1
export NCCL_DEBUG=INFO

gpu_count=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
if [ -z "$SLURM_GPUS" ]; then
  export NPROC_PER_NODE=$gpu_count
else
  export NPROC_PER_NODE=$(($SLURM_GPUS<$gpu_count?$SLURM_GPUS:$gpu_count))
fi
export NNODES=$SLURM_NNODES
export NODE_RANK=$SLURM_NODEID
export MASTER_PORT=8111
export DATASET_ENABLE_CACHE=1

source $work_dir/scripts/get_master_addr.sh

swift sft \
    --model_type $model_type \
    --model_id_or_path $model_id_or_path \
    --template_type $template_type \
    --dataset $dataset \
    --max_length $max_length \
    --lazy_tokenize $lazy_tokenize \
    --sft_type lora \
    --lora_target_modules 'q_proj' 'k_proj' 'v_proj' \
    --init_lora_weights 'True' \
    --learning_rate '1e-4' \
    --gradient_accumulation_steps '16' \
    --eval_steps '500' \
    --save_steps '500' \
    --save_total_limit '-1' \
    --logging_steps '1' \
    --batch_size $batch_size \
    --eval_batch_size $batch_size \
    --add_output_dir_suffix False \
    --ddp_backend nccl \
    --ddp_timeout '1800' \
    $deepspeed_arg \
    --output_dir $work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID) \
    --logging_dir $work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID)/runs \
    --ignore_args_error True
