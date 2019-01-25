#!/usr/bin/env bash

set -e

data="input/data.txt"
params="input/params.txt"

python data.py
ghc -isrc src/Main.hs
./src/Main <<< "$data $params"
