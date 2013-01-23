#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 i; exit; fi

i=$1
dir=$2
if [ "$dir" != "" ] && [ -d $dir ]; then cd $dir; fi

outfile=output_all$i.txt

echo i is $i > $outfile 2>&1

source ~/.bashenv

all_tiles.sh $i 1  >> $outfile 2>&1




