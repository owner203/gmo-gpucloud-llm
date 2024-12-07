#!/bin/bash

#SBATCH --job-name=test
#SBATCH -p part-cpu
#SBATCH --nodes=1
#SBATCH -o logs/%x.%j.out.log
#SBATCH -e logs/%x.%j.err.log

echo "Job started at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"

text1='Hello'
text2='World'

srun scripts/test.sh \
    ${text1:-"Hello"} \
    ${text2:-"World"}

echo "Job finished at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"
