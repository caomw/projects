#!/bin/bash

cmd=$(cat list.txt | head -n $1 | tail -n 1)

echo Machine is $(uname -n)

echo $cmd

. isis_setup.sh

echo "Machine is " $(uname -n) >  output_run"$1".txt

$cmd >> output_run"$1".txt
