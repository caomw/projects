#!/bin/bash

workDir=$(pwd)
#wallTime="0:15:00"; maxNodes=2; mpp=2.0; # for debugging
#wallTime="4:00:00"; maxNodes=4; mpp=2.0;
wallTime="20:00:00"; maxNodes=16; mpp=0.5
levels=5

#mpp=1.0 # must have .0

#for mpp in 1.0; do
#for mpp in 2.0; do

    for ((i=7; i<=9; i++)); do
    #for ((i=1; i<=1; i++)); do
        index=$i
        prefix=run$index
        cmd="$workDir/run_map.sh $index $mpp 1 $levels t9 $workDir $wallTime $maxNodes"
        echo $cmd
        $cmd
    done

#    sleep 1800

#done
