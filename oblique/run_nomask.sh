#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

. isis_setup.sh

stereo --max-valid-triangulation-error 80 --disable-fill-holes --alignment-method homography --subpixel-mode 1 --corr-timeout 200 --universe-center Zero --near-universe-radius 1730400 --far-universe-radius 1745400 sub4_cubes_45deg/AS15-M-1442.lev1.cub sub4_cubes_45deg/AS15-M-1443.lev1.cub run_nomask/run
point2dem -r moon --nodata-value -32767 run_nomask/run-PC.tif
~/bin/show_dems.pl run_nomask2/run-DEM.tif run_nomask/run-DEM.tif
