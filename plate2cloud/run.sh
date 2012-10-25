#!/bin/bash

d=$1
l=$2
n=$3
i=$4
uname -a
export LOCAL=0
export WRITE=0
export MISSING=1
source ~/.bashenv
cmd="$HOME/visionworkbench/src/vw/Plate/plate2kml $CTX -o $d -p mars -l $l -n $n -i $i" 
echo $cmd
time $cmd # > /dev/null 2>&1


