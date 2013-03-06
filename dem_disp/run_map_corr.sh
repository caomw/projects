#!/bin/bash

# map-projected images

export SAMPLE=5

# # temporary!
# rm -rfv map_seed1_subpix2
# stereo M0100115.map.cub E0201461.map.cub map_seed1_subpix2/res -s stereo.map --corr-search -1000 -1000 1000 1000 --subpixel-mode 2 --corr-seed-mode 1 --disparity-estimation-dem ref-DEM-map.tif --disparity-estimation-dem-accuracy 1 --alignment-method none
# time_run.sh point2dem -r mars  map_seed1_subpix2/res-PC.tif
# time_run.sh show_dems.pl map_seed1_subpix2/res-DEM.tif
# exit

rm -fv map_seed2_subpix2/res-D_sub.* map_seed2_subpix2/res-D.*
. isis_setup.sh
stereo_corr M0100115.map.cub E0201461.map.cub map_seed2_subpix2/res -s stereo.map --corr-search -1000 -1000 1000 1000 --subpixel-mode 2 --corr-seed-mode 2 --disparity-estimation-dem ref-DEM-map.tif --disparity-estimation-dem-accuracy 10 --alignment-method none
time_run.sh ~/bin/cmp_images.sh x map_seed2_subpix2/res-D_sub.tif map_seed2_subpix2/res-D_sub_prev.tif
