#!/bin/bash

# echo $*
# if [ "$#" -lt 8 ]; then echo Usage: $0 index mpp subpix levels tag workDir wallTime maxNodes; exit; fi

tag=map2
mpp=5 # 0.5
subpix=1 # To do: Switch to subpix=2
d=data
#img1=$d/09OCT11191503-P1BS_R1C1-052783426010_01_P001.rpc_"$mpp"mpp.tif
img1=$d/09OCT11191503-P1BS_R1C1-052783426010_01_P001.rpc_"$mpp"mpp_coarse_crop.tif
cam1=$d/09OCT11191503-P1BS_R1C1-052783426010_01_P001.xml
#img2=$d/09OCT11191555-P1BS_R1C1-052783426010_01_P001.rpc_"$mpp"mpp.tif
img2=$d/09OCT11191555-P1BS_R1C1-052783426010_01_P001.rpc_"$mpp"mpp_coarse_crop.tif
cam2=$d/09OCT11191555-P1BS_R1C1-052783426010_01_P001.xml
dem=$d/filled_dem.tif

runDir=res_map_mpp"$mpp"_"$tag"

opts="$img1 $img2 $cam1 $cam2 $runDir/res $dem --corr-max-levels 5 -t dg -s stereo.default --alignment-method none --subpixel-mode $subpix --disable-fill-holes --threads 32  --subpixel-h-kernel 19  --subpixel-v-kernel 19 --corr-seed-mode 1"

rm -rfv $runDir; mkdir -p $runDir
time_run.sh stereo $opts
time_run.sh point2dem -r earth --threads 1 --nodata-value -32767 $runDir/res-PC.tif
show_dems.pl $runDir/res-DEM.tif
