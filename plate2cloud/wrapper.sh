#!/bin/bash

d=$1
l=$2
n=$3
i=$4

uname -a

baseDir=$HOME/plate2kml_example

mkdir -p $baseDir/scratch/p$i >/dev/null 2>&1
cd    $baseDir/scratch/p$i
pwd

rm -fv $baseDir/scratch/output_run* >/dev/null 2>&1
cmd="$baseDir/run.sh $d $l $n $i"
echo $cmd
nohup $cmd > $baseDir/scratch/output_run"_"$d"_"$i.txt 2>&1 &
echo ""
