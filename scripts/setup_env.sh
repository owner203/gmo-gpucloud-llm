#!/bin/bash

#
# This script should be run on a GPU node.
#

work_dir=${1:-$HOME/gmo-gpucloud-llm}

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

curl -L -o $work_dir/packages/pytorch.tar.gz https://github.com/pytorch/pytorch/releases/download/v2.5.1/pytorch-v2.5.1.tar.gz
tar -zxvf $work_dir/packages/pytorch.tar.gz -C $work_dir/packages
cd $work_dir/packages/pytorch-v2.5.1
pip install -r requirements.txt
python setup.py install

curl -L -o $work_dir/packages/DeepSpeed.tar.gz https://github.com/microsoft/DeepSpeed/archive/refs/tags/v0.15.4.tar.gz
tar -zxvf $work_dir/packages/DeepSpeed.tar.gz -C $work_dir/packages
cd $work_dir/packages/DeepSpeed-0.15.4
pip install .

curl -L -o $work_dir/packages/ms-swift.tar.gz https://github.com/modelscope/ms-swift/archive/refs/tags/v2.6.1.tar.gz
tar -zxvf $work_dir/packages/ms-swift.tar.gz -C $work_dir/packages
cd $work_dir/packages/ms-swift-2.6.1
pip install -e '.[all]'

echo "Virtual environment setup complete"
