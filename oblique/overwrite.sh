#!/bin/zsh

links=""

prefix1=run3_sub4_25deg
prefix2=run4_sub4_25deg

for f in $(cat good.txt); do

    ((g=$f+1))
    if [ $g -lt 1000 ]; then
        dir1="$prefix1"_"$f"_0"$g"
        dir2="$prefix2"_"$f"_0"$g"
    else
        dir1="$prefix1"_"$f"_"$g"
        dir2="$prefix2"_"$f"_"$g"
    fi

    ls $dir1/img-DEM.tif
    #cp -fv $dir1/img-DEM.tif $dir1/img-DEM.tif_bk
    #cp -fv $dir2/img-DEM.tif $dir1/img-DEM.tif 
    
done
