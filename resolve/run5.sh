#!/bin/bash

. isis_setup.sh

if [ "$#" -lt 1 ]; then echo Usage: $0 mpp;  exit; fi

mpp="$1"mpp

a=M139939938LE
b=M139946735RE

cam2map from = 85s_10w/"$a".cal.cub to = 85s_10w/"$a".map.cal.$mpp.cub map = sp$mpp.map pixres=map
cam2map from = 85s_10w/"$b".cal.cub to = 85s_10w/"$b".map.cal.$mpp.cub map = sp$mpp.map pixres=map

for t in integer parabola bayes; do 
    res=results_"$mpp"_"$t"_85s_10w_"$a"_"$b"/"$a"_"$b"
    time stereo -s stereo_"$t".default --threads 16 85s_10w/"$a".map.cal.$mpp.cub 85s_10w/"$b".map.cal.$mpp.cub $res
    point2dem --nodata-value -32767 --threads 1 -r moon $res-PC.tif
    show_dems.pl $res-DEM.tif
done
