#!/bin/bash

text1=${1:-'Hello'}
text2=${2:-'World'}

echo "${text1} ${text2} from $(hostname)"
