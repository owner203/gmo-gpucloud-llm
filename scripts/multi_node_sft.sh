#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=${1:-$HOME/gmo-gpucloud-llm}
model_type=$2
model_id_or_path=$3
template_type=$4
dataset=$5

max_length=${6:-2048}
lazy_tokenize=${7:-'False'}
sft_type=${8:-'lora'}
lora_target_modules=${9:-'DEFAULT'}
init_lora_weights=${10:-'True'}
learning_rate=${11:-'None'}
gradient_accumulation_steps=${12:-'None'}
batch_size=${13:-1}
ds_config=${14:-'None'}
checkpoint_path=${15:-'None'}
resume_only_model=${16:-'False'}

if [ "$learning_rate" != "None" ]; then
  learning_rate_arg="--learning_rate $learning_rate"
else
  learning_rate_arg=""
fi

if [ "$gradient_accumulation_steps" != "None" ]; then
  gradient_accumulation_steps_arg="--gradient_accumulation_steps $gradient_accumulation_steps"
else
  gradient_accumulation_steps_arg=""
fi

if [ "$ds_config" != "None" ]; then
  deepspeed_arg="--deepspeed $ds_config"
  save_steps=50
else
  deepspeed_arg=""
  save_steps=500
fi

if [ "$checkpoint_path" != "None" ]; then
  resume_from_checkpoint_arg="--resume_from_checkpoint $checkpoint_path"
  resume_only_model_args="--resume_only_model $resume_only_model"
else
  resume_from_checkpoint_arg=""
  resume_only_model_args=""
fi

source $work_dir/scripts/activate_env.sh $work_dir

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
export OMP_NUM_THREADS=112

source $work_dir/scripts/get_master_addr.sh

swift sft \
    --model_type $model_type \
    --model_id_or_path $model_id_or_path \
    --template_type $template_type \
    --dataset $dataset \
    --max_length $max_length \
    --lazy_tokenize $lazy_tokenize \
    --sft_type $sft_type \
    --lora_target_modules $lora_target_modules \
    --init_lora_weights $init_lora_weights \
    $learning_rate_arg \
    $gradient_accumulation_steps_arg \
    --eval_steps $save_steps \
    --save_steps $save_steps \
    --save_total_limit '-1' \
    --logging_steps '1' \
    --batch_size $batch_size \
    --eval_batch_size $batch_size \
    --add_output_dir_suffix False \
    --ddp_backend nccl \
    --ddp_timeout '1800' \
    $deepspeed_arg \
    $resume_from_checkpoint_arg \
    $resume_only_model_args \
    --output_dir $work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID) \
    --logging_dir $work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID)/runs \
    --ignore_args_error True
