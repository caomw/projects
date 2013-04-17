#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

dir=small
rm -rfv $dir
mkdir -p $dir
time_run.sh /usr/bin/python $HOME/projects/StereoPipeline/src/asp/Tools/sparse_disp left_small.tif right_small.tif -o $dir/map --processes 16

# ~/bin/cmp_images.sh x gold_small/D_sub.tif $dir/D_sub.tif
# ~/bin/cmp_images.sh x gold_small/D_sub_spread.tif $dir/D_sub_spread.tif
# echo diff is $(diff gold_small/map.csv $dir/map.csv)
