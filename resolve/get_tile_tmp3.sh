#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 dirName; exit; fi

dir=$1 #results_1mpp_M139939938LE_M139946735RE_run2
tag=stereographic4

opts=$(gdalinfo $dir/res-DEM.tif | grep Center | perl -pi -e "s#[\(\,)]##g" | perl -pi -e "s#^.*?\s+(.*?)\s+(.*?)\s+.*?\$#--stereographic  --proj-lon \$1 --proj-lat \$2  --proj-scale 1#g")

#cmd="point2dem --dem-spacing 1 --nodata-value -32767 --threads 1 -r moon $dir/res-PC.tif $opts -o $dir/res-$tag"
#echo $cmd
#$cmd

tag2=14
mpp=1
if [ "$mpp" -eq 1 ]; then 
    pref=$dir/res-$tag-DEM
    tag2=""
else
    pref=$dir/res-$tag-DEM_sub10
fi

wid=$(gdalinfo $pref.tif | grep "Size is" | perl -pi -e "s#,##g" | print_col.pl 3)
((ht=10*wid))
((ht=5*wid))

if [ "$dir" = "results_1mpp_M139919591LE_M139926365RE_run2" ]; then
    ((ht=5*wid))
fi

if [ "$dir" = "results_1mpp_M139912793LE_M139919591RE_run2" ]; then
    ((ht=5*wid))
fi

if [ "$dir" = "results_1mpp_M139906018LE_M139912793RE_run2" ]; then
    ((ht=4*wid))
fi

croppedDEM=$pref"_tile"$tag2.tif
croppedDRG=$dir/res-$tag-DRG_tile$tag2.tif

gdal_translate -srcwin 0 $ht $wid $wid $pref.tif $croppedDEM
remote_copy.pl $croppedDEM $L2
show_dems.pl $croppedDEM
echo $croppedDEM

# #point2dem --errorimage --nodata-value -32767 --threads 1 -r moon $dir/res-PC.tif -o $dir/res-$tag --stereographic --proj-lat -85.2731008 --proj-lon -5.6125116 --proj-scale 1
# point2dem --dem-spacing 1 --nodata-value -32767 --threads 1 -r moon $dir/res-PC.tif --stereographic --proj-lat -90 --proj-lon 0 --proj-scale 1 -o $dir/res-$tag 
# #point2dem --dem-spacing 1 --nodata-value -32767 --threads 1 -r moon {}/res-PC.tif --stereographic --proj-lat -90 --proj-lon 0 --proj-scale 1 -o {}/res-$tag 

# gdal_translate  -srcwin 0 32000 3329 3329 $dir/res-$tag-DEM.tif $dir/res-$tag-DEM_tile.tif
# gdal_translate  -srcwin 0 32000 3329 3329 $dir/res-$tag-DEMError.tif $dir/res-$tag-DEMError_tile.tif

cub=$(echo $dir | perl -pi -e "s#^.*?(M.*?)_.*?\$#\$1#g")
time $HOME/bin/tile_orthoproject.pl --threads 16 $croppedDEM 85s_10w/$cub.cal.cub --mpp $mpp $croppedDRG
image2qtree.pl $croppedDRG 


gdaldem hillshade $croppedDEM $dir/res-$tag-hill_tile.tif

remote_copy.pl  $dir/res-$tag-hill_tile.tif $L2

# # Get rid of bigtif
# gdal_translate -co compress=lzw $dir/res-$tag-DRG_tile.tif $dir/res-$tag-DRG_tile_tmp.tif
# mv -fv $dir/res-$tag-DRG_tile_tmp.tif $dir/res-$tag-DRG_tile.tif


