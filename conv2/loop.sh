#!/bin/bash


for l in 2 3 4 5 1 0; do
    tag=t1; sub=2; levels=$l; subpix=0;
    ./run16.sh $sub $subpix $levels $tag > output_sub"$sub"_subpix$subpix"_levels"$levels"_"$tag.txt 2>&1
done
