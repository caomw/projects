#!/bin/bash


# Good regression testcase

dir=run3
rm -rfv $dir
mkdir -p $dir
time_run.sh stereo --corr-max-levels 5 --corr-seed-mode 1 --left-image-crop-win 14336 0 1000 1000 --threads=16 -s stereo.default -t dg left_sub2.tif right_sub2.tif WV02_10NOV261950171-P1BS-1030010008866100_sub2.xml WV02_10NOV261951496-P1BS-103001000888E600_sub2.xml $dir/res --subpixel-mode 2 --disable-fill-holes --corr-search -1405 -1740 1680 790 --alignment-method homography

time_run.sh point2dem $dir/res-PC.tif
time_run.sh show_dems.pl $dir/res-DEM.tif
