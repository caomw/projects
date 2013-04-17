#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

dir=sub2
rm -rfv $dir
mkdir -p $dir
#time_run.sh /nasa/python/2.7.3/bin/python $HOME/projects/StereoPipeline/src/asp/Tools/sparse_disp left_sub2.tif right_sub2.tif -o $dir/map --processes 16
time_run.sh /usr/bin/python $HOME/projects/StereoPipeline/src/asp/Tools/sparse_disp left_sub2.tif right_sub2.tif $dir/map --processes 16

~/bin/cmp_images.sh x gold/map-D_sub.tif $dir/map-D_sub.tif
~/bin/cmp_images.sh x gold/map-D_sub_spread.tif $dir/map-D_sub_spread.tif
echo diff is $(diff gold/map.csv $dir/map.csv)
