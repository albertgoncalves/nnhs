#!/usr/bin/env bash

set -e

data="input/data.txt"
params="input/params.txt"

python data.py
runghc -isrc src/Main.hs <<< "$data $params"
