#!/usr/bin/env bash

data=$1
params=$2

runghc parseData.hs <<< "$data $params"
