#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 i mpp; exit; fi

source ~/.bashenv # need this if running on the supercomp

i=$1
mpp=$2

dir=$(ls -dl res*1mpp*run3 | head -n $i | tail -n 1 | print_col.pl 0 | perl -pi -e "s#\s##g")
echo $dir
cubDir=85s_10w
leftCub=$(echo $dir | perl -pi -e "s#^.*?(M.*?)_.*?\$#\$1#g"); leftCub=$cubDir/$leftCub.cal.cub
rightCub=$(echo $dir | perl -pi -e "s#^.*?M.*?_(.*?)_.*?\$#\$1#g"); rightCub=$cubDir/$rightCub.cal.cub
echo $leftCub $rightCub
a=${leftCub/$cubDir\//}; a=${a/.cal.cub/}
b=${rightCub/$cubDir\//}; b=${b/.cal.cub/}
echo $a $b
outDir="results_"$mpp"mpp"_"$a"_"$b""_run3"
DEM_prefix=$dir/res-DEM

. isis_setup.sh

# rm -fv $DEM_prefix[0-9]*tif $dir/LRONAC* $dir/*DEM* $dir/*PC* # this removes even DEM tiles!
# time_run.sh stereo_fltr --compute-error-vector -s stereo.default --threads 16 $leftCub $rightCub $outDir/res  --disable-fill-holes
# time_run.sh stereo_tri --compute-error-vector -s stereo.default --threads 16 $leftCub $rightCub $outDir/res  --disable-fill-holes
# time_run.sh point2dem  --stereographic --proj-lon 0 --proj-lat -90 --proj-scale 1 --dem-spacing $mpp --nodata-value -32767 --threads 1 -r moon $dir/res-PC.tif -o $dir/res --errorimage

time_run.sh tile.pl $DEM_prefix.tif
time_run.sh tile.pl $DEM_prefix"Error".tif

cub=$(echo $dir | perl -pi -e "s#^.*?(M.*?)_.*?\$#\$1#g")

for DEMTile in $DEM_prefix[0-9]*tif; do
    rename.pl $DEMTile
done

for DEMErrorTile in $DEM_prefix"Error"[0-9]*tif; do
    rename.pl $DEMErrorTile
done

for DEMTile in $dir/LRONAC_DEM_*tif; do

    DRGTile=$(echo $DEMTile | perl -pi -e "s#DEM#DRG#g")
    ErrorTile=$(echo $DEMTile | perl -pi -e "s#DEM#DEMError#g")
    #remote_copy.pl $DEMTile $ErrorTile $L2
    time_run.sh $HOME/bin/tile_orthoproject.pl --threads 16 $DEMTile $cubDir/$cub.cal.cub --mpp $mpp $DRGTile
    #remote_copy.pl $DRGTile $L2
    show_dems.pl $DEMTile
    image2qtree.pl $DRGTile
    hillTile=$(echo $DEMTile | perl -pi -e "s#DEM#hillshade#g")
    gdaldem hillshade $DEMTile $hillTile
    #remote_copy.pl $hillTile $L2
done

#rm_empty.pl $dir

for DEMTile in $dir/LRONAC_DEM_*tif; do
    ErrorTile=$(echo $DEMTile | perl -pi -e "s#DEM#DEMError#g")
    plot_err.sh $ErrorTile 1
done