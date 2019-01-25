#!/usr/bin/env bash

set -e

dir="input"
data="$dir/data.txt"
params="$dir/params.txt"

cd $dir
python data.py
cd ../

ghc -isrc src/Main.hs
./src/Main <<< "$data $params"
