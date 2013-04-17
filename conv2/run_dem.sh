#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: `basename $0` level align local" >&2
    exit 85
fi

level=$1
align=$2
local=$3
acc=$4
runDir="res_sub2_level"$level"_local"$local"_align"$align"_acc"$acc

outFile="output_"$runDir.txt
echo Will write to $outFile

exec &> $outFile 2>&1

rm -rfv $runDir

opts="WV01_11JAN131652222-P1BS-10200100104A0300_sub2.tif WV01_11JAN131653180-P1BS-1020010011862E00_sub2.tif WV01_11JAN131652222-P1BS-10200100104A0300_sub2.xml WV01_11JAN131653180-P1BS-1020010011862E00_sub2.xml $runDir/res --session-type dg --stereo-file stereo.default --corr-seed-mode 2 --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disable-fill-holes --disparity-estimation-dem-error $acc --alignment-method $align --threads 16 --subpixel-mode 1 --corr-max-levels $level"
if [ "$local" -ne 0 ]; then opts="$opts --use-local-homography"; fi

time_run.sh stereo $opts
time_run.sh point2dem -r earth --nodata-value -32767 $runDir/res-PC.tif
