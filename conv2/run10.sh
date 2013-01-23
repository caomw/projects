#!/bin/sh

if [ "$#" -lt 1 ]; then echo Usage: $0 sub scale; exit; fi

sub=$1
scale=1
levels=5
tag="x"
dir=res_sub"$sub"_scale$scale"_levels"$levels"_"$tag
((pct=100/sub))
((a=100*scale/sub))
#((startx=17408/sub));((starty=12288/sub))
((startx=13408/sub)); ((starty=8288/sub))
win=4098

img1=WV01_11JAN131652222-P1BS-10200100104A0300.tif
cam1=WV01_11JAN131652222-P1BS-10200100104A0300.xml
img2=WV01_11JAN131653180-P1BS-1020010011862E00.tif
cam2=WV01_11JAN131653180-P1BS-1020010011862E00.xml

dem=krigged_dem_nsidc_ndv0_fill.tif
# if [ $sub -eq 1 ]; then
#win_opt="--left-image-crop-win $startx $starty $win $win"
# else
win_opt=""
# fi
src="--corr-search -$a -$a $a $a"
opt="$win_opt $src --corr-max-levels $levels -t dg -s stereo.default --threads 30 --alignment-method none"
if [ $sub -ne 1 ]; then
    cam1_sub=${cam1/.xml/_sub$sub.xml}
    cam2_sub=${cam2/.xml/_sub$sub.xml}
    if [ ! -e $cam1_sub ]; then ./dg_resample.py $cam1 $pct $cam1_sub; fi
    if [ ! -e $cam2_sub ]; then ./dg_resample.py $cam2 $pct $cam2_sub; fi

    img1_sub=${img1/.tif/_sub$sub.tif}
    img2_sub=${img2/.tif/_sub$sub.tif}
    if [ ! -e $img1_sub ]; then time_run.sh gdal_translate -outsize $pct% $pct% $img1 $img1_sub; fi
    if [ ! -e $img2_sub ]; then time_run.sh gdal_translate -outsize $pct% $pct% $img2 $img2_sub; fi
else
    img1_sub=$img1
    img2_sub=$img2
    cam1_sub=$cam1
    cam2_sub=$cam2
fi
opts="$opt $img1_sub $img2_sub $cam1_sub $cam2_sub $dir/res $dem"
export DO_DUMP=0

time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem -r earth --threads 1 $dir/res-PC.tif
show_dems.pl $dir/res-DEM.tif 
