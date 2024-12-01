# GMO GPU Cloud LLM

[GMO GPU Cloud](https://gpucloud.gmo/) LLM example cases on Slurm.

## Environment

- [PyTorch](https://github.com/pytorch/pytorch) == `2.5.1`
- [DeepSpeed](https://github.com/microsoft/DeepSpeed) == `0.16.0`
- [ModelScope SWIFT](https://github.com/modelscope/ms-swift) == `2.6.1`

```bash
cd $HOME && git clone https://github.com/owner203/gmo-gpucloud-llm.git
cd $HOME/gmo-gpucloud-llm
sbatch setup_env.sbatch
```

## Working Directory

`$HOME/gmo-gpucloud-llm`

## LLMs and Datasets

`$HOME/gmo-gpucloud-llm/LLM-Research`

## Fine-Tuning

```bash
sbatch multi_node_sft.sbatch
```

## Starting Web UI (Single Node)
