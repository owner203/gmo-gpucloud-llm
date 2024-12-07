#!/bin/bash

#SBATCH --job-name=multi_node_sft
#SBATCH -p part-share
#SBATCH --nodes=1
#SBATCH -o logs/%x.%j.out.log
#SBATCH -e logs/%x.%j.err.log

echo "Job started at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"

work_dir=$HOME/gmo-gpucloud-llm
model_type='llama3_1-70b-instruct'
model_id_or_path=$work_dir/LLM-Research/Meta-Llama-3.1-70B-Instruct
template_type='llama3'
dataset=$work_dir/LLM-Research/dataset/alpaca_cleaned_ja.json

#
# LoRA
#
max_length=2048
lazy_tokenize='False'
sft_type='lora'
lora_target_modules='DEFAULT'
init_lora_weights='True'
learning_rate='1e-4'
gradient_accumulation_steps=16
batch_size=4
ds_config=$work_dir/LLM-Research/ds_config/zero3_offload.json
checkpoint_path='None'
resume_only_model='False'

#
# LoRA (target modules)
#
# max_length=2048
# lazy_tokenize='False'
# sft_type='lora'
# lora_target_modules='q_proj,k_proj,v_proj,o_proj,gate_proj,up_proj,down_proj,embed_tokens,lm_head'
# init_lora_weights='True'
# learning_rate='1e-4'
# gradient_accumulation_steps=16
# batch_size=1
# ds_config='None'
# checkpoint_path='None'
# resume_only_model='False'

#
# FULL
#
# max_length=4096
# lazy_tokenize='False'
# sft_type='full'
# lora_target_modules='DEFAULT'
# init_lora_weights='True'
# learning_rate='None'
# gradient_accumulation_steps='None'
# batch_size=1
# ds_config=$work_dir/LLM-Research/ds_config/zero3_offload.json
# checkpoint_path='None'
# resume_only_model='False'

mkdir -p $work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID)/runs
srun scripts/multi_node_sft.sh \
    $work_dir \
    $model_type \
    $model_id_or_path \
    $template_type \
    $dataset \
    $max_length \
    $lazy_tokenize \
    $sft_type \
    $lora_target_modules \
    $init_lora_weights \
    $learning_rate \
    $gradient_accumulation_steps \
    $batch_size \
    $ds_config \
    $checkpoint_path \
    $resume_only_model

echo "Job finished at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"
