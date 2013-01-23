#!/bin/bash

files=""
prevDir=""
i=0
count=0;
for dir in results_1mpp_*run3; do
    
    ((i++));
    if [ $i -ne 7 ]; then prevDir=$dir; continue; fi
    
    files=$(ls $dir/LRONAC_DRG_*.tif)

    currFiles=""
    for f in $files; do 

        tag=$(echo $f | perl -pi -e "s#[^\w]##g")
        tag="$tag"6
        #currFiles="$currFiles $f"
        currFiles="$f"
        echo $tag
        prevFiles=$(ls $prevDir/LRONAC_DRG_*.tif)
        allFiles="$prevFiles $currFiles"
        
        pct=3
        ((sub=100/pct))
        prefix=run$count
        echo $prefix
    
        vrt=$prefix.tif
        scaled_vrt=$prefix"_"$tag"_sub$sub.tif"
        time_run.sh gdalbuildvrt -srcnodata 0 $vrt $allFiles
        time_run.sh gdal_translate -outsize $pct% $pct% $vrt $scaled_vrt
        time_run.sh image2qtree.pl $scaled_vrt

        echo $f
        exit
    done
done
