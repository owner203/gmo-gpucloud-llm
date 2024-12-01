#!/bin/bash

#SBATCH --job-name=setup_env
#SBATCH -p part-share
#SBATCH --nodes=1
#SBATCH -o logs/%x.%j.out.log
#SBATCH -e logs/%x.%j.err.log

echo "Job started at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"

work_dir=$HOME/gmo-gpucloud-llm

srun scripts/setup_env.sh $work_dir

echo "Job finished at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"
