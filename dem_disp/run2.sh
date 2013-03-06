#!/bin/bash

seed=$1
tag=$2
dir=run_seed$seed"_tag"$tag
export SAMPLE=5

. isis_setup.sh

pref=$dir/res
rm -rfv $dir

time_run.sh stereo M0100115.cub E0201461.cub $pref -s stereo.nonmap --subpixel-mode 2 --corr-seed-mode $seed --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-accuracy 1
time_run.sh point2dem -r mars $pref-PC.tif
time_run.sh show_dems.pl $pref-DEM.tif
