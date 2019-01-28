#!/usr/bin/env bash

data="data.txt"
params="params.txt"

runghc parseData.hs <<< "$data $params"
