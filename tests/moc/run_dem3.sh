#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

. isis_setup.sh

#dir=nonmap13 # none
#dir=nonmap15 # homography
#dir=nonmap17 # no dem dsub
#dir=nonmap19 # dem dsub with subpixel
#dir=nonmap21 # dem dsub with subpixel with no alignment
dir=nonmap23 # dem dsub with subpixel with no alignment hack rfne
rm -rfv $dir
export LOCAL=1
stereo M0100115.cub E0201461.cub $dir/nonmap -s stereo.default --corr-seed-mode 2 --alignment-method none --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-error 5  --subpixel-mode 2
