#!/bin/bash


# Good regression testcase

dir=run11

#rm -rfv $dir
#mkdir -p $dir

rm -f $dir/res-D_sub.tif $dir/res-D.tif

opts="--corr-max-levels 5 --corr-seed-mode 2 --left-image-crop-win 14336 0 1000 1000 --threads=16 -s stereo.default -t dg left_sub2.tif right_sub2.tif WV02_10NOV261950171-P1BS-1030010008866100_sub2.xml WV02_10NOV261951496-P1BS-103001000888E600_sub2.xml $dir/res --subpixel-mode 1 --disable-fill-holes --corr-search -1405 -1740 1680 790 --alignment-method homography --disparity-estimation-dem run3/res-DEM.tif  --disparity-estimation-dem-accuracy 1"
time_run.sh stereo_corr $opts

# time_run.sh stereo_rfne $opts

# time_run.sh stereo_fltr $opts
# time_run.sh stereo_tri $opts

# time_run.sh point2dem $dir/res-PC.tif
# time_run.sh show_dems.pl $dir/res-DEM.tif
