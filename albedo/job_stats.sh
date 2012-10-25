#!/bin/bash

if [ "$#" -ne 1 ]; then 
    echo Usage: $0 outFile.txt
fi

outFile=$1

for m in byss lunokhod1 lunokhod2 alderaan; do
    s=$(grep -i jobid $outFile | grep "at " | grep -v "=-1" | grep $m | wc | awk '{print $1}');
    echo $m $s;
done