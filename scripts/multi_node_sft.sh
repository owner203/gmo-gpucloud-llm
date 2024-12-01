#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=$HOME/gmo-gpucloud-llm
model_type='llama3-70b-instruct'
model_id_or_path=$work_dir/LLM-Research/Meta-Llama-3-70B-Instruct
template_type='llama3'
dataset=alpaca-zh
output_dir=$work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID)

source $work_dir/scripts/module_load.sh

source $work_dir/.venv/bin/activate

export NCCL_DEBUG=INFO
export NCCL_P2P_LEVEL=PXB
export NCCL_SOCKET_NTHREADS=4
export NCCL_NSOCKS_PERTHREAD=4
export NCCL_IB_TIMEOUT=20
export NCCL_IB_RETRY_CNT=7
export NCCL_NET_GDR_LEVEL=PXB
export NCCL_NVLS_ENABLE=1

export NNODES=$SLURM_NNODES
export NODE_RANK=$SLURM_NODEID
export NPROC_PER_NODE=8
export MASTER_PORT=8111

source $work_dir/scripts/get_master_addr.sh

swift sft \
    --model_type $model_type \
    --model_id_or_path $model_id_or_path \
    --template_type $template_type \
    --dataset $dataset \
    --max_length '2048' \
    --lazy_tokenize 'False' \
    --lora_target_modules 'q_proj' 'k_proj' 'v_proj' \
    --init_lora_weights 'True' \
    --learning_rate '1e-4' \
    --gradient_accumulation_steps '16' \
    --eval_steps '500' \
    --save_steps '500' \
    --save_total_limit '-1' \
    --logging_steps '1' \
    --batch_size '1' \
    --eval_batch_size '1' \
    --add_output_dir_suffix False \
    --ddp_backend nccl \
    --ddp_timeout '1800' \
    --output_dir $output_dir \
    --logging_dir $output_dir/runs \
    --ignore_args_error True
