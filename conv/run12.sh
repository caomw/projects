#!/bin/bash


# Good regression testcase

seed=2
dir=run12_seed$seed
rm -fv $dir/res-D_sub.* $dir/res-D.*
export t=16;
export SAMPLE=5;
kill_by_name.sh stereo
time_run.sh stereo --compute-low-res-disparity-only --corr-max-levels 5 --corr-seed-mode $seed --threads $t -s stereo.default -t dg left_sub2.tif right_sub2.tif WV02_10NOV261950171-P1BS-1030010008866100_sub2.xml WV02_10NOV261951496-P1BS-103001000888E600_sub2.xml $dir/res --subpixel-mode 2 --disable-fill-holes --corr-search -1405 -1740 1680 790 --alignment-method homography --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 1
~/bin/cmp_images.sh x $dir/res-D_sub.tif $dir/res-D_subO.tif
time_run.sh point2dem $dir/res-PC.tif
time_run.sh show_dems.pl $dir/res-DEM.tif

#rm -rfv $dir; mkdir -p $dir
# --left-image-crop-win 14336 0 1000 1000
# opts="--corr-max-levels 5 --corr-seed-mode 2 --threads=16 -s stereo.default -t dg left_sub2.tif right_sub2.tif WV02_10NOV261950171-P1BS-1030010008866100_sub2.xml WV02_10NOV261951496-P1BS-103001000888E600_sub2.xml $dir/res --subpixel-mode 2 --disable-fill-holes --corr-search -1405 -1740 1680 790 --alignment-method homography --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 1"
# time_run.sh stereo_ $opts
# time_run.sh point2dem $dir/res-PC.tif
# time_run.sh show_dems.pl $dir/res-DEM.tif
