#!/bin/bash

work_dir=${1:-$HOME/gmo-gpucloud-llm}

source $work_dir/scripts/module_load.sh $work_dir

if [ -d "$work_dir/.venv" ]; then
  source $work_dir/.venv/bin/activate
  echo "Virtual environment activated"
else
  echo "Virtual environment not found. Please run setup_env.sh first"
  exit 1
fi
