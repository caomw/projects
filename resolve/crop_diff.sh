#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 file1.tif file2.tif startx starty; exit; fi

file1=$1
file2=$2
startx=$3
starty=$4

echo "gdalinfo -stats $file1"
echo "gdalinfo -stats $file2"

wd=$(gdalinfo -stats $file1 | grep Size | perl -pi -e "s#^.*?(\d+).*?\n#\$1#g")
ht=$(gdalinfo -stats $file1 | grep Size | perl -pi -e "s#^.*?,\s*(\d+).*?\n#\$1#g")

echo "++$wd++$ht++"

((wd=wd-startx))
((ht=ht-starty))

rm -fv out1.tif out2.tif

gdal_translate -srcwin $startx $starty $wd $ht $file1 out1.tif
gdal_translate -srcwin $startx $starty $wd $ht $file2 out2.tif

~/bin/cmp_images.sh x out1.tif out2.tif

