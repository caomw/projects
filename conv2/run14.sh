#!/bin/sh

if [ "$#" -lt 1 ]; then echo Usage: $0 sub scale; exit; fi

sub=$1
scale=$2
levels=$3
tag=$4
dir=res_sub"$sub"_scale$scale"_levels"$levels"_"$tag
((pct=100/sub))
# ((a=100*scale/sub))
#((startx=17408/sub));((starty=12288/sub))
#((startx=13408/sub)); ((starty=8288/sub))
((startx=10*1024/sub)); ((starty=7*1024/sub))
#((startx=10240/sub)); ((starty=6144/sub))
((win=3072/sub))

img1=WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m.tif
cam1=WV01_11JAN131652222-P1BS-10200100104A0300.xml
img2=WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m.tif
cam2=WV01_11JAN131653180-P1BS-1020010011862E00.xml

dem=krigged_dem_nsidc_ndv0_fill.tif
#win_opt="--left-image-crop-win $startx $starty $win $win"
win_opt=""
((p=16*253/sub)); ((q=16*218/sub))

((a=p-100)); ((b=q-100));
((c=p+100)); ((d=q+100));
#src="--corr-search $a $b $c $d"
#src="--corr-search 153 118 353 318"
src="--corr-search 2000 1600 2400 2100"
opt="$win_opt $src --corr-max-levels $levels -t dg -s stereo.default --threads 30 --alignment-method none --subpixel-mode 1" # --disable-fill-holes
if [ $sub -ne 1 ]; then
    cam1_sub=${cam1/.xml/_sub$sub.xml}
    cam2_sub=${cam2/.xml/_sub$sub.xml}
    if [ ! -e $cam1_sub ]; then time_run.sh ./dg_resample.py $cam1 $pct $cam1_sub; fi
    if [ ! -e $cam2_sub ]; then time_run.sh ./dg_resample.py $cam2 $pct $cam2_sub; fi

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
export DO_DUMP=0

# echo "xxx" $(grep -i -E "numrows|numcolumns" $cam1_sub)
# echo "xxx" $(grep -i -E "numrows|numcolumns" $cam2_sub)
# echo "xxx " $(gdalinfo $img1_sub | grep -i size)
# echo "xxx " $(gdalinfo $img2_sub | grep -i size)

mkdir -p $dir

# img1_crop=$dir/${img1_sub/.tif/_crop.tif}
# img2_crop=$dir/${img2_sub/.tif/_crop.tif}
# gdal_translate -projwin \-1579886.751 \-675105.500 \-1576686.268 \-678305.500 $img1_sub $img1_crop
# gdal_translate -projwin \-1579886.751 \-675105.500 \-1576686.268 \-678305.500 $img2_sub $img2_crop
# viewq2.sh $img1_crop
# viewq2.sh $img2_crop

opts="$opt $img1_sub $img2_sub $cam1_sub $cam2_sub $dir/res $dem"

time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem -r earth --threads 1 $dir/res-PC.tif
show_dems.pl $dir/res-DEM.tif 
