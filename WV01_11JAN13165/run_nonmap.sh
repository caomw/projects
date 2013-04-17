#!/bin/bash

if [ "$#" -lt 3 ]; then echo Usage: $0 pct seed local; exit; fi

pct=$1   # 100 or 50
seed=$2  # 1 or 2
local=$3 # 1 or 0

dir="res_"$pct"pct_"$seed"seed_"$local"local"

left=10200100104A0300
right=1020010011862E00

if [ "$pct" -eq "50" ]; then
    left=$left.r50
    right=$right.r50
fi

export LOCAL=$local
stereo $left.tif $right.tif $left.xml $right.xml $dir/res -s stereo.default -t dg --alignment-method homography --subpixel-mode 1 --corr-seed-mode $seed --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 100 --corr-max-levels 2

point2dem -r earth --nodata-value -32767  $dir/res-PC.tif
