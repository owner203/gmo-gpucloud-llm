#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=${1:-$HOME/gmo-gpucloud-llm}
pytorch_version=${2:-"2.5.1"}
deepspeed_version=${3:-"0.15.4"}
ms_swift_version=${4:-"2.6.1"}

echo "Setting up virtual environment"

if [ -d "$work_dir/.venv" ]; then
  rm -rf $work_dir/.venv
fi
if [ -d "$work_dir/packages" ]; then
  rm -rf $work_dir/packages
fi

source $work_dir/scripts/module_load.sh $work_dir

python -m venv $work_dir/.venv
source $work_dir/.venv/bin/activate

pip install --upgrade pip

mkdir -p $work_dir/packages

curl -L -o $work_dir/packages/pytorch.tar.gz https://github.com/pytorch/pytorch/releases/download/v$pytorch_version/pytorch-v$pytorch_version.tar.gz
tar -zxvf $work_dir/packages/pytorch.tar.gz -C $work_dir/packages
cd $work_dir/packages/pytorch-v$pytorch_version
pip install -r requirements.txt
python setup.py install

curl -L -o $work_dir/packages/DeepSpeed.tar.gz https://github.com/microsoft/DeepSpeed/archive/refs/tags/v$deepspeed_version.tar.gz
tar -zxvf $work_dir/packages/DeepSpeed.tar.gz -C $work_dir/packages
cd $work_dir/packages/DeepSpeed-$deepspeed_version
pip install .

curl -L -o $work_dir/packages/ms-swift.tar.gz https://github.com/modelscope/ms-swift/archive/refs/tags/v$ms_swift_version.tar.gz
tar -zxvf $work_dir/packages/ms-swift.tar.gz -C $work_dir/packages
cd $work_dir/packages/ms-swift-$ms_swift_version
pip install -e '.[all]'

echo "Virtual environment setup complete"
