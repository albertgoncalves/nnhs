#!/usr/bin/env bash

set -e

alias hlint=hlint -c=never
alias hindent="hindent --indent-size 4 --sort-imports --line-length 79"

data="input/data.txt"
params="input/params.txt"

for hs in $(ls src/*.hs); do
    printf "\n$hs\n"
    hlint $hs
    hindent $hs
done

printf "\n"
python data.py
ghc -isrc src/Main.hs
./src/Main <<< "$data $params"
