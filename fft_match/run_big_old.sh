#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

dir=big_old
rm -rfv $dir
mkdir -p $dir
time_run.sh /usr/bin/python $HOME/projects/StereoPipeline/src/asp/Tools/sparse_disp_old.py  WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m_crop.tif WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m_crop.tif -o $dir/map --processes 32

~/bin/cmp_images.sh x gold_big/D_sub.tif $dir/D_sub.tif
~/bin/cmp_images.sh x gold_big/D_sub_spread.tif $dir/D_sub_spread.tif
echo diff is $(diff gold_big/map.csv $dir/map.csv)
