#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=${1:-$HOME/gmo-gpucloud-llm}
port=${2:-8888}
lang=${3:-'en'}

source $work_dir/scripts/activate_env.sh $work_dir

source $work_dir/scripts/set_env_vars.sh

swift web-ui \
    --host $(hostname) \
    --port $port \
    --lang $lang \
    --share False
