#!/bin/zsh

if [ "$#" -lt 4 ]; then echo Usage: $0 sub subpix levels tag; exit; fi

sub=$1
subpix=$2
levels=$3
tag=$4
dir=res_sub"$sub"_subpix$subpix"_levels"$levels"_"$tag
((pct=100/sub))

img1=WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m.tif
cam1=WV01_11JAN131652222-P1BS-10200100104A0300.xml
img2=WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m.tif
cam2=WV01_11JAN131653180-P1BS-1020010011862E00.xml

dem=krigged_dem_nsidc_ndv0_fill.tif
#win_opt="--left-image-crop-win $startx $starty $win $win"
win_opt=""
((a=-100/sub)); ((b=-100/sub)); ((c=100/sub)); ((d=100/sub));
src="--corr-search $a $b $c $d"
opt="$win_opt $src --corr-max-levels $levels -t dg -s stereo.default --threads 16 --alignment-method none --subpixel-mode $subpix --disable-fill-holes"
if [ $sub -ne 1 ]; then

    #cam1_sub=${cam1/.xml/_sub$sub.xml}
    #cam2_sub=${cam2/.xml/_sub$sub.xml}
    #if [ ! -e $cam1_sub ]; then time_run.sh ./dg_resample.py $cam1 $pct $cam1_sub; fi
    #if [ ! -e $cam2_sub ]; then time_run.sh ./dg_resample.py $cam2 $pct $cam2_sub; fi
    # Must not scale the cameras for map-projected images!
    cam1_sub=$cam1
    cam2_sub=$cam2

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

rm -rfv $dir; mkdir -p $dir

img1_crop=$dir/${img1_sub/.tif/_crop.tif}
img2_crop=$dir/${img2_sub/.tif/_crop.tif}
if [ 1 -eq 1 ]; then
    p=-1579886; q=-687905; r=-1577846; s=-689945; # run1, fails at level 3
    #p=-1579886; q=-675105; r=-1577846; s=-689945; # temporary
    #p=-1579886; q=-675105; r=-1577846; s=-677145; # run2, succeds at level 3
    #p=-1589488.202; q=-668705.5; r=-1567418.202; s=-693005.5; # whole box
    time_run.sh gdal_translate -projwin $p $q $r $s $img1_sub $img1_crop
    time_run.sh gdal_translate -projwin $p $q $r $s $img2_sub $img2_crop
    #viewq2.sh $img1_crop
    #viewq2.sh $img2_crop
    opts="$opt $img1_crop $img2_crop $cam1_sub $cam2_sub $dir/res $dem"
else
    opts="$opt $img1_sub $img2_sub $cam1_sub $cam2_sub $dir/res $dem"
fi

time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem -r earth --threads 1 $dir/res-PC.tif --nodata-value -32767
show_dems.pl $dir/res-DEM.tif
