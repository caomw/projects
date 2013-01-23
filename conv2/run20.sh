#!/bin/sh

if [ "$#" -lt 4 ]; then echo Usage: $0 sub levels ratio dir; exit; fi

sub=$1
levels=$2
ratio=$3
pdir=$4
if [ "$pdir" != "" ]; then cd $pdir; fi

source ~/.bashenv
export S_RATIO=$ratio
echo value is $S_RATIO
if [ "$pdir" != "" ]; then cd $pdir; fi

dir="res_sub"$sub"_levels"$levels"_ratio"$ratio

echo Will write to output_"$dir".txt
exec &> output_"$dir".txt 2>&1

img1=WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m.tif
cam1=WV01_11JAN131652222-P1BS-10200100104A0300.xml
img2=WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m.tif
cam2=WV01_11JAN131653180-P1BS-1020010011862E00.xml
dem=krigged_dem_nsidc_ndv0_fill.tif
((a=-100/sub)); ((b=-100/sub)); ((c=100/sub)); ((d=100/sub));
#((a=-400/sub)); ((b=-400/sub)); ((c=400/sub)); ((d=400/sub));
src="--corr-search $a $b $c $d"
opt="$src --corr-max-levels $levels -t dg -s stereo.default --threads 16 --alignment-method none --subpixel-mode 2 --disable-fill-holes"
if [ $sub -ne 1 ]; then
    img1_sub=${img1/.tif/_sub$sub.tif}
    img2_sub=${img2/.tif/_sub$sub.tif}
    if [ ! -e $img1_sub ]; then time_run.sh gdal_translate -outsize $pct% $pct% $img1 $img1_sub; fi
    if [ ! -e $img2_sub ]; then time_run.sh gdal_translate -outsize $pct% $pct% $img2 $img2_sub; fi
else
    img1_sub=$img1
    img2_sub=$img2
fi
export DO_DUMP=0

img1_crop=${img1_sub/.tif/_crop.tif}
img2_crop=${img2_sub/.tif/_crop.tif}
p=-1589488.202; q=-668705.5; r=-1567418.202; s=-693005.5; # whole box
if [ ! -e $img1_crop ]; then time_run.sh gdal_translate -projwin $p $q $r $s $img1_sub $img1_crop; fi
if [ ! -e $img2_crop ]; then time_run.sh gdal_translate -projwin $p $q $r $s $img2_sub $img2_crop; fi

mkdir -p $dir;
    
opts="$opt $img1_crop $img2_crop $cam1 $cam2 $dir/res $dem" 
    
time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem -r earth --threads 1 $dir/res-PC.tif
show_dems.pl $dir/res-DEM.tif 
