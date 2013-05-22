#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi


for v in 8 9 10 11 12; do
for s in 1; do
#for s in 0 m; do
#for v in 4 5 6; do

    for g in "o" "n"; do

        cd $HOME/projects/visionworkbench
        if [ "$g" = "o" ]; then
            cp src/vw/Core/Cache.cc_old src/vw/Core/Cache.cc
        else
            cp src/vw/Core/Cache.cc_new src/vw/Core/Cache.cc
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

        touch src/vw/Core/Cache.cc
        make -j 10

        cd $HOME/projects/conv2
        rm -rfv res;
        time_run.sh stereo_pprc $li $ri $lx $rx res/res --threads 16 > output_"g"$g"_s"$s"_v$v".txt 2>&1

    done
done
done