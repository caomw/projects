#!/bin/bash


export SAMPLE=1
rm -fv nomap_seed2_subpix2/res-D_sub.* nomap_seed2_subpix2/res-D.*
. isis_setup.sh
stereo_corr --compute-low-res-disparity-only M0100115.cub E0201461.cub nomap_seed2_subpix2/res -s stereo.nonmap --corr-search -1000 -1000 1000 1000 --subpixel-mode 2 --corr-seed-mode 2 --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-error 1

~/bin/cmp_images.sh x nomap_seed2_subpix2/res-D_sub.tif nomap_seed2_subpix2/res-D_sub_prev.tif
