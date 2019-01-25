#!/usr/bin/env bash

data=$1
params=$2

runghc -isrc src/Main.hs <<< "$data $params"
