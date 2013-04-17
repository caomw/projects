#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

prog="/nobackupnfs1/oalexan1/projects/StereoPipeline/src/asp/Tools/sparse_disp"
files="WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m_crop.tif WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m_crop.tif"

t=12000
a="-o run00/map --startx 0  --starty 0  --tile_size $t"
b="-o run01/map --startx 0  --starty $t --tile_size $t"
c="-o run10/map --startx $t --starty 0  --tile_size $t"
d="-o run11/map --startx $t --starty $t --tile_size $t"

parallel time_run.sh /usr/bin/python $prog $files --processes 4 {} ::: "$a" "$b" "$c" "$d"
