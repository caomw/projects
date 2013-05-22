#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 g s; exit; fi

g=$1
s=$2
v=6

if [ "$g" = "n" ]; then
    exe=$HOME/projects/StereoPipeline/src/asp/Tools/stereo_pprc
else
    exe=$HOME/projects/StereoPipeline_debug/src/asp/Tools/stereo_pprc
fi

lx=WV01_11JAN131652222-P1BS-10200100104A0300.xml
rx=WV01_11JAN131653180-P1BS-1020010011862E00.xml
if [ "$s" -eq "0" ] || [ "$s" -eq "1" ] || [ "$s" -eq "2" ]; then
    li=tmp_sub$s.tif
    ri=tmp_sub$s.tif
fi
if [ "$s" = "m" ]; then
    li=lbig.tif; lx=lbig.xml
    ri=rbig.tif; rx=rbig.xml
fi
cd $HOME/projects/conv2
dir="g"$g"_s"$s"_v"$v
rm -rfv $dir
time_run.sh $exe $li $ri $lx $rx $dir/res --threads 16 > output_"$dir".txt 2>&1
