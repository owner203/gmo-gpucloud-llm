# GMO GPU Cloud LLM

[GMO GPU Cloud](https://gpucloud.gmo/) LLM training test using Slurm.

## Requirements

- [PyTorch](https://github.com/pytorch/pytorch) == `2.5.1`
- [DeepSpeed](https://github.com/microsoft/DeepSpeed) == `0.15.4`
- [ModelScope SWIFT](https://github.com/modelscope/ms-swift) == `2.6.1`

```bash
cd $HOME && git clone https://github.com/owner203/gmo-gpucloud-llm.git

cd $HOME/gmo-gpucloud-llm

sbatch setup_env.sbatch
```

## Working Directory

`$HOME/gmo-gpucloud-llm`

## LLMs and Datasets

- [Llama-3.1-70B-Instruct](https://huggingface.co/meta-llama/Llama-3.1-70B-Instruct)
- [alpaca_ja](https://github.com/shi3z/alpaca_ja)

```bash
cd $HOME/gmo-gpucloud-llm

source scripts/activate_env.sh

mkdir -p LLM-Research/dataset

huggingface-cli download meta-llama/Llama-3.1-70B-Instruct --local-dir LLM-Research/Meta-Llama-3.1-70B-Instruct

curl -L -o LLM-Research/dataset/alpaca_cleaned_ja.json https://raw.githubusercontent.com/shi3z/alpaca_ja/refs/heads/main/alpaca_cleaned_ja.json
```

## Fine-Tuning

```bash
sbatch -p part-share --nodes=2 multi_node_sft.sbatch
```

## Web UI (Single Node)
