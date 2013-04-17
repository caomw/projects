#!/bin/bash

session=$1
seed=$2
dir=$3

source ~/.bashenv
if [ "$dir" != "" ]; then cd $dir; fi

#--compute-low-res-disparity-only
#for session in rpc dg; do
export t=16
export SAMPLE=1
#    for seed in 1 2; do
win="--left-image-crop-win 27648 0 2048 2048" #win="--left-image-crop-win 28000 0 1000 1000"
dir=run12_"$session"_"seed$seed"

exec &> output_"$dir".txt 2>&1

opts="$win --corr-max-levels 5 --corr-seed-mode $seed --threads $t -s stereo.default -t $session WV02_10NOV261950171-P1BS-1030010008866100.tif WV02_10NOV261951496-P1BS-103001000888E600.tif WV02_10NOV261950171-P1BS-1030010008866100.xml WV02_10NOV261951496-P1BS-103001000888E600.xml $dir/res --subpixel-mode 2 --disable-fill-holes --corr-search -1405 -1740 1680 790 --alignment-method homography --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 100"

rm -rfv $dir;
#rm -fv $dir/res-D_sub.* $dir/res-D.*
#kill_by_name.sh stereo

time_run.sh stereo $opts
time_run.sh point2dem $dir/res-PC.tif
time_run.sh show_dems.pl $dir/res-DEM.tif
#    done
#done

        #time_run.sh ~/bin/cmp_images.sh x $dir/res-D_sub.tif $dir/res-D_sub_prev.tif

# # temporary
# rm -rfv $dir
# mkdir -p $dir
# time_run.sh stereo $opts
# time_run.sh point2dem $dir/res-PC.tif
# show_dems.pl $dir/res-DEM.tif
# exit
# --left-image-crop-win 14336 0 1000 1000
# opts="--corr-max-levels 5 --corr-seed-mode 2 --threads=16 -s stereo.default -t dg left_sub2.tif right_sub2.tif WV02_10NOV261950171-P1BS-1030010008866100_sub2.xml WV02_10NOV261951496-P1BS-103001000888E600_sub2.xml $dir/res --subpixel-mode 2 --disable-fill-holes --corr-search -1405 -1740 1680 790 --alignment-method homography --disparity-estimation-dem krigged_dem_nsidc_ndv0_fill.tif --disparity-estimation-dem-error 1"
# time_run.sh stereo $opts
# time_run.sh point2dem $dir/res-PC.tif
# time_run.sh show_dems.pl $dir/res-DEM.tif
