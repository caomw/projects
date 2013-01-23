#!/bin/zsh

if [ "$#" -lt 1 ]; then echo Usage: $0 sub subpix; exit; fi

sub=$1
subpix=$2
levels=$3
tag=$4
dir=res_sub"$sub"_subpix$subpix"_levels"$levels"_"$tag
((pct=100/sub))
# ((a=100*subpix/sub))
#((startx=17408/sub));((starty=12288/sub))
#((startx=13408/sub)); ((starty=8288/sub))
#((startx=10*1024/sub)); ((starty=7*1024/sub))
#((startx=10240/sub)); ((starty=6144/sub))
#((win=3072/sub))

img1=WV01_11JAN131652222-P1BS-10200100104A0300_ortho1.0m.tif
cam1=WV01_11JAN131652222-P1BS-10200100104A0300.xml
img2=WV01_11JAN131653180-P1BS-1020010011862E00_ortho1.0m.tif
cam2=WV01_11JAN131653180-P1BS-1020010011862E00.xml

dem=krigged_dem_nsidc_ndv0_fill.tif
#win_opt="--left-image-crop-win $startx $starty $win $win"
win_opt=""
# ((p=16*253/sub)); ((q=16*218/sub))
# ((a=p-100)); ((b=q-100));
# ((c=p+100)); ((d=q+100));
#((a=2*2000/sub)); ((b=2*1600/sub)); ((c=2*2400/sub)); ((d=2*2100/sub)); # good
((a=-200/sub)); ((b=-200/sub)); ((c=200/sub)); ((d=200/sub));
#src="--corr-search $a $b $c $d"
#src="--corr-search 153 118 353 318"
src="--corr-search $a $b $c $d"
opt="$win_opt $src --corr-max-levels $levels -t dg -s stereo.default --threads 16 --alignment-method none --subpixel-mode $subpix --disable-fill-holes"
if [ $sub -ne 1 ]; then
#     cam1_sub=${cam1/.xml/_sub$sub.xml}
#     cam2_sub=${cam2/.xml/_sub$sub.xml}
#     if [ ! -e $cam1_sub ]; then time_run.sh ./dg_resample.py $cam1 $pct $cam1_sub; fi
#     if [ ! -e $cam2_sub ]; then time_run.sh ./dg_resample.py $cam2 $pct $cam2_sub; fi
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
export DO_DUMP=0
export S_RATIO=0

# echo "xxx" $(grep -i -E "numrows|numcolumns" $cam1_sub)
# echo "xxx" $(grep -i -E "numrows|numcolumns" $cam2_sub)
# echo "xxx " $(gdalinfo $img1_sub | grep -i size)
# echo "xxx " $(gdalinfo $img2_sub | grep -i size)

mkdir -p $dir

img1_crop=$dir/${img1_sub/.tif/_crop.tif}
img2_crop=$dir/${img2_sub/.tif/_crop.tif}
if [ 1 -eq 1 ]; then
    #p=-1579886; q=-675105; r=-1576686; s=-678305;
    #((dx=r-p));
    #((dy=s-q));
#     ((q=q+4*dy));
#     ((s=s+4*dy));
#     ((dx=r-p))
#     ((dy=s-q))
    #((dx=dx*102/160))
    #((dy=dy*102/160))
    #((r=p+dx))
    #((s=q+dy))
    #echo "p=$p; q=$q; r=$r; s=$s;"
    #p=-1579886; q=-675105; r=-1577846; s=-677145; # succeds at level 3
    p=-1579886; q=-687905; r=-1577846; s=-689945; # fails at level 3!
    #p=-1589488.202; q=-668705.5; r=-1567418.202; s=-693005.5; # whole box
    time_run.sh gdal_translate -projwin $p $q $r $s $img1_sub $img1_crop
    time_run.sh gdal_translate -projwin $p $q $r $s $img2_sub $img2_crop
    #gdal_translate -projwin \-1579886.751 \-675105.500 \-1576686.268 \-678305.500 $img1_sub $img1_crop # good
    #gdal_translate -projwin \-1579886.751 \-675105.500 \-1576686.268 \-678305.500 $img2_sub $img2_crop # good
#     gdal_translate -projwin \-1582886.751 \-672105.500 \-1573686.268 \-688005.500 $img1_sub $img1_crop 
#     gdal_translate -projwin \-1582886.751 \-672105.500 \-1573686.268 \-688005.500 $img2_sub $img2_crop 
#     ((a=2*3*1024/sub));  ((a=a/1024)); ((a=a*1024));
#     ((b=2*10*1024/sub));  ((b=b/1024)); ((b=b*1024));
#     ((c=2*7*1024/sub));  ((c=c/1024)); ((c=c*1024));
#     ((d=2*12*1024/sub)); ((d=d/1024)); ((d=d*1024));
#     gdal_translate -srcwin $a $b 1024 1024 $img1_sub $img1_crop 
#     gdal_translate -srcwin $c $d 1024 1024 $img2_sub $img2_crop 
    viewq2.sh $img1_crop
    viewq2.sh $img2_crop
    opts="$opt $img1_crop $img2_crop $cam1_sub $cam2_sub $dir/res $dem" 
else
    opts="$opt $img1_sub $img2_sub $cam1_sub $cam2_sub $dir/res $dem"
fi

time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem -r earth --threads 1 $dir/res-PC.tif
show_dems.pl $dir/res-DEM.tif 
