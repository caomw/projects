#!/bin/bash

# echo $*
# if [ "$#" -lt 8 ]; then echo Usage: $0 index mpp subpix levels tag workDir wallTime maxNodes; exit; fi

# index=$1 # must be between 1 and 9
# mpp=$2
# subpix=$3
# levels=$4
# tag=$5
# workDir=$6
# wallTime=$7
# maxNodes=$8

sw=400.0 # search window size
tag=t2
mpp=10.0
subpix=1 # To do: Switch to subpix=2
d=data
img1=$d/WV01_11JAN131652284-P1BS-10200100104A0300_ortho"$mpp"m.tif
img2=$d/WV01_11JAN131653232-P1BS-1020010011862E00_ortho"$mpp"m.tif
cam1=$d/WV01_11JAN131652284-P1BS-10200100104A0300.xml
cam2=$d/WV01_11JAN131653232-P1BS-1020010011862E00.xml
dem=$d/krigged_dem_nsidc_ndv0_fill.tif

runDir=res_mpp"$mpp"_"$tag"_sw"$sw"

a=$(echo "scale=16; -$sw/$mpp" | bc)
b=$(echo "scale=16; -$sw/$mpp" | bc)
c=$(echo "scale=16;  $sw/$mpp" | bc)
d=$(echo "scale=16;  $sw/$mpp" | bc)
src=$(echo "--corr-search $a $b $c $d" | perl -pi -e "s#\.\d*##g")
opts="$img1 $img2 $cam1 $cam2 $runDir/res $dem $src --corr-max-levels 5 -t dg -s stereo.default --alignment-method none --subpixel-mode $subpix --disable-fill-holes --threads 32"

rm -rfv $runDir; mkdir -p $runDir
time_run.sh stereo $opts
time_run.sh point2dem -r earth --threads 1 --nodata-value -32767 $runDir/res-PC.tif
show_dems.pl $runDir/res-DEM.tif
