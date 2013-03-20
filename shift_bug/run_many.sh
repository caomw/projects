#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 index; exit; fi
index=$1

((count=0))
for f in *500; do
    for g in *A00; do

        ((count++))
        if [ $count -ne $index ]; then continue; fi

        li=$f/*r20*tif
        ri=$g/*r20*tif
        lc=$f/*r20*xml
        rc=$g/*r20*xml

        d=$f"_"$g"_run"
        time_run.sh stereo $li $ri $lc $rc  --alignment-method homography $d/res -t dg
        exit
        time_run.sh point2dem -r earth $d/res-PC.tif
        time_run.sh show_dems.pl $d/res-DEM.tif
    done
done
