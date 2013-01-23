#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 i mpp; exit; fi

source ~/.bashenv # need this if running on the supercomp

i=$1
mpp=$2

cubDir=85s_10w
inDir=$(ls -dl res*1mpp*run3 | head -n $i | tail -n 1 | print_col.pl 0 | perl -pi -e "s#\s##g")
echo $inDir
leftCub=$(echo $inDir | perl -pi -e "s#^.*?(M.*?)_.*?\$#\$1#g"); leftCub=$cubDir/$leftCub.cal.cub
rightCub=$(echo $inDir | perl -pi -e "s#^.*?M.*?_(.*?)_.*?\$#\$1#g"); rightCub=$cubDir/$rightCub.cal.cub
echo $leftCub $rightCub
a=${leftCub/$cubDir\//}; a=${a/.cal.cub/}
b=${rightCub/$cubDir\//}; b=${b/.cal.cub/}
echo $a $b
outDir="results_"$mpp"mpp"_"$a"_"$b""_run4" # note: run4 here

. isis_setup.sh

# DEM error with holes
# time_run.sh point2dem  --stereographic --proj-lon 0 --proj-lat -90 --proj-scale 1 --dem-spacing $mpp --nodata-value -32767 --threads 1 -r moon $inDir/res-PC.tif -o $inDir/res --errorimage

# DEM without holes
mkdir $outDir
# cp -fv $inDir/res-* $outDir
# rm -fv $outDir/LRONAC* $outDir/*DEM* $outDir/*PC* # this removes even DEM tiles!
# time_run.sh stereo_fltr --compute-error-vector -s stereo.default --threads 16 $leftCub $rightCub $outDir/res
#time_run.sh stereo_tri --compute-error-vector -s stereo.default --threads 16 $leftCub $rightCub $outDir/res

# Get DRG
time_run.sh point2dem  --stereographic --proj-lon 0 --proj-lat -90 --proj-scale 1 --dem-spacing $mpp --nodata-value 0 --threads 1 -r moon $outDir/res-PC.tif -o $outDir/res --orthoimage $leftCub

# Get DEM (overwriting the DEM but not the DRG from the previous step)
time_run.sh point2dem  --stereographic --proj-lon 0 --proj-lat -90 --proj-scale 1 --dem-spacing $mpp --nodata-value -32767 --threads 1 -r moon $outDir/res-PC.tif -o $outDir/res

cp -fv $inDir/res-DEMError.tif $outDir

DEM_prefix=$outDir/res-DEM
DRG_prefix=$outDir/res-DRG
time_run.sh tile.pl $DEM_prefix.tif;         rename.pl $outDir/$DEM_prefix[0-9]*.tif
time_run.sh tile.pl $DEM_prefix"Error".tif;  rename.pl $outDir/$DEM_prefix"Error"[0-9]*.tif
time_run.sh tile.pl $DRG_prefix.tif;         rename.pl $outDir/$DRG_prefix[0-9]*.tif

rm_empty.pl $outDir
