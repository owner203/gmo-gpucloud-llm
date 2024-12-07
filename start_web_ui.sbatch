#!/bin/bash

#SBATCH --job-name=start_web_ui
#SBATCH -p part-share
#SBATCH --nodes=1
#SBATCH -o logs/%x.%j.out.log
#SBATCH -e logs/%x.%j.err.log

echo "Job started at $(TZ=Asia/Tokyo date +%Y/%m/%d\ %H:%M:%S)"

echo "After the Web UI starts, please do:"
echo "  1. Run 'ssh -L 18888:$SLURM_JOB_NODELIST:8888 -N -p 8822 $(whoami)@connect.gpucloud.gmo -i <YourPrivateKey>' on your local machine"
echo "  2. Open 'http://localhost:18888' in your browser"
echo "After using, please ensure to STOP this job by 'scancel $SLURM_JOB_ID'"

work_dir=$HOME/gmo-gpucloud-llm
port=8888
lang=en

echo "Starting Web UI..."
srun scripts/start_web_ui.sh \
    ${work_dir:-$HOME/gmo-gpucloud-llm} \
    ${port:-8888} \
    ${lang:-'en'}
