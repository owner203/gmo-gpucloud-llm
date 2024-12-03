#!/bin/bash

#SBATCH --job-name=multi_node_sft
#SBATCH -p part-share
#SBATCH --nodes=1
#SBATCH -o logs/%x.%j.out.log
#SBATCH -e logs/%x.%j.err.log

echo "Job started at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"

work_dir=$HOME/gmo-gpucloud-llm
model_type='llama3_1-70b-instruct'
# model_type='llama3-70b-instruct'
model_id_or_path=$work_dir/LLM-Research/Meta-Llama-3.1-70B-Instruct
# model_id_or_path=$work_dir/LLM-Research/Meta-Llama-3-70B-Instruct
template_type='llama3'
dataset=$work_dir/LLM-Research/dataset/alpaca_cleaned_ja.json
# dataset=$work_dir/LLM-Research/dataset/alpaca_gpt4_data_zh.json

max_length=2048
lazy_tokenize='False'
batch_size=8
# batch_size=1
ds_config=$work_dir/LLM-Research/ds_config/zero3.json
# ds_config='None'
checkpoint_path='None'
# checkpoint_path=$work_dir/output/multi_node_sft.4996/checkpoint-50
# resume_only_model='False'

mkdir -p $work_dir/output/$(echo $SLURM_JOB_NAME.$SLURM_JOB_ID)/runs
srun scripts/multi_node_sft.sh $work_dir $model_type $model_id_or_path $template_type $dataset $max_length $lazy_tokenize $batch_size $ds_config $checkpoint_path

echo "Job finished at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"
