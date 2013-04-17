#!/bin/bash

. isis_setup.sh

# Gives different results each time it is run!!!
dir=local1
opts="M0100115.cub E0201461.cub $dir/res --corr-seed-mode 2 --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-error 5 --subpixel-mode 1 --stereo-file stereo.default  --left-image-crop-win 0 1024 672 4864 --use-local-homography --alignment-method homography"
rm -rfv $dir; time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri $opts
point2dem -r mars $dir/res-PC.tif

~/bin/cmp_images.sh x "$dir"_gold/res-D.tif $dir/res-D.tif
~/bin/cmp_images.sh x "$dir"_gold/res-RD.tif  $dir/res-RD.tif
#~/bin/cmp_images.sh x "$dir"_gold/res-F.tif  $dir/res-F.tif
