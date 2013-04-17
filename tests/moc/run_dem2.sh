#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

. isis_setup.sh

#dir=nonmap12 # none
#dir=nonmap14 # homography
#dir=nonmap16 # no dem dsub
#dir=nonmap18 # dem dsub with subpixel
dir=nonmap20 # dem dsub with subpixel with no alignment
rm -rfv $dir
export LOCAL=0
stereo M0100115.cub E0201461.cub $dir/nonmap -s stereo.default --corr-seed-mode 2 --alignment-method none --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-error 5 --subpixel-mode 2
