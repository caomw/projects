#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

. isis_setup.sh

rm -rfv nonmap11
stereo M0100115.cub E0201461.cub nonmap11/nonmap -s stereo.default --subpixel-mode 1 --corr-seed-mode 1 --alignment-method none  # --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-error 5
