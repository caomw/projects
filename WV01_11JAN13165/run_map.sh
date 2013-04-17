#!/bin/bash

echo $*

if [ "$#" -lt 8 ]; then echo Usage: $0 index mpp subpix levels tag workDir wallTime maxNodes; exit; fi

source ~/.bashenv

index=$1 # must be between 1 and 9
mpp=$2
subpix=$3
levels=$4
tag=$5
workDir=$6
wallTime=$7
maxNodes=$8

cd $workDir
runDir=res_index"$index"_mpp"$mpp"_subpix$subpix"_levels"$levels"_"$tag

outFile=output_"$runDir".txt
rm -fv $outFile
echo Will write to $outFile
exec &> $outFile 2>&1

echo "Now in directory: $(pwd)"

sub=1
((pct=100/sub))

data=$HOME/projects/data/WV01_11JAN13165
opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

img1_unp=$(ls $data/W*300.tif | grep -v ortho | grep -v quart | head -n $index |tail -n 1)
cam1=${img1_unp/.tif/.xml}
img1=${img1_unp/.tif/_ortho"$mpp"m.tif}
echo $img1_unp $img1 $cam1
if [ ! -e "$img1" ]; then
    rpc_mapproject --tr $mpp --t_srs "$opt" krigged_dem_nsidc_ndv0_fill.tif $img1_unp $cam1 $img1
fi

img2_unp=$(ls $data/W*E00.tif | grep -v ortho | grep -v quart | head -n $index |tail -n 1)
cam2=${img2_unp/.tif/.xml}
img2=${img2_unp/.tif/_ortho"$mpp"m.tif}
echo $img2_unp $img2 $cam2
if [ ! -e "$img2" ]; then
    rpc_mapproject --tr $mpp --t_srs "$opt" krigged_dem_nsidc_ndv0_fill.tif $img2_unp $cam2 $img2
fi

#img1=$data/WV01_11JAN131652222-P1BS-10200100104A0300_ortho"$mpp"m.tif
#cam1=$data/WV01_11JAN131652222-P1BS-10200100104A0300.xml
#img2=$data/WV01_11JAN131653180-P1BS-1020010011862E00_ortho"$mpp"m.tif
#cam2=$data/WV01_11JAN131653180-P1BS-1020010011862E00.xml

dem=krigged_dem_nsidc_ndv0_fill.tif
#win_opt="--left-image-crop-win $startx $starty $win $win"
win_opt=""
a=$(echo "scale=16; -100.0/$mpp" | bc)
b=$(echo "scale=16; -100.0/$mpp" | bc)
c=$(echo "scale=16;  100.0/$mpp" | bc)
d=$(echo "scale=16;  100.0/$mpp" | bc)
src=$(echo "--corr-search $a $b $c $d" | perl -pi -e "s#\.\d*##g")

opt="$win_opt $src --corr-max-levels $levels -t dg -s stereo.default --alignment-method none --subpixel-mode $subpix --disable-fill-holes"
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

rm -rfv $runDir; mkdir -p $runDir

img1_crop=$(echo $img1_sub | perl -pi -e "s#^.*\/##g"); img1_crop=$runDir/${img1_crop/.tif/_crop.tif}
img2_crop=$(echo $img2_sub | perl -pi -e "s#^.*\/##g"); img2_crop=$runDir/${img2_crop/.tif/_crop.tif}
if [ 1 -eq 1 ]; then
    #p=-1579886; q=-687905; r=-1577846; s=-689945; # run1, fails at level 3
    #p=-1579886; q=-675105; r=-1577846; s=-689945; # temporary
    #p=-1579886; q=-675105; r=-1577846; s=-677145; # run2, succeds at level 3
    #p=-1589488.202; q=-668705.5; r=-1567418.202; s=-693005.5; # whole box
    #time_run.sh gdal_translate -projwin $p $q $r $s $img1_sub $img1_crop
    #time_run.sh gdal_translate -projwin $p $q $r $s $img2_sub $img2_crop
    win=$($HOME/bin/intersection.pl $img1_sub $img2_sub)
    time_run.sh gdal_translate -projwin $win $img1_sub $img1_crop
    time_run.sh gdal_translate -projwin $win $img2_sub $img2_crop

    #viewq2.sh $img1_crop
    #viewq2.sh $img2_crop
    opts="$opt $img1_crop $img2_crop $cam1_sub $cam2_sub $runDir/res $dem"
else
    opts="$opt $img1_sub $img2_sub $cam1_sub $cam2_sub $runDir/res $dem"
fi

prefix=$runDir
prefix=${prefix:7:6}
tooldir=$HOME/projects/WV01_11JAN13165/tools

$tooldir/do_submit.sh $wallTime $maxNodes $runDir $prefix $tooldir $opts

# time_run.sh stereo_pprc $opts
# time_run.sh stereo_corr $opts
# time_run.sh stereo_rfne $opts
# time_run.sh stereo_fltr $opts
# time_run.sh stereo_tri  $opts
# time_run.sh point2dem -r earth --threads 1 --nodata-value -32767 $runDir/res-PC.tif
# # show_dems.pl $runDir/res-DEM.tif
