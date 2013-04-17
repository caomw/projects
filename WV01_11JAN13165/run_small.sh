#!/bin/bash

if [ "$#" -lt 4 ]; then echo Usage: $0 pct seed local tag; exit; fi

pct=$1   # 100 or 50
seed=$2  # 1 or 2
local=$3 # 1 or 0
tag=$4

# pct=5
# seed=2
# local=0
levels=5

left=10200100104A0300.r5
right=1020010011862E00.r5

runDir="small_"$pct"pct_"$seed"seed_"$local"local_"$tag
rm -rfv $runDir

opts="$left.tif $right.tif $left.xml $right.xml $runDir/res -s stereo.default -t dg --alignment-method homography --subpixel-mode 1 --corr-seed-mode $seed --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 100 --corr-max-levels $levels"

if [ "$local" -ne 0 ]; then opts="$opts --use-local-homography"; fi

stereo $opts
