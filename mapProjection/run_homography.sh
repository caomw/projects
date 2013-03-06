#!/bin/sh


in1=WV01_11JUN171531433-P1BS-102001001549B500
in2=WV01_11JUN171532408-P1BS-1020010014597A00
gdt=$HOME/projects/base_system/bin/gdal_translate

dir="run_hom"
rm -rfv $dir; mkdir $dir

# Stereo of non-map-projected images
std=stereo_homography"_"$ls.default
time stereo --threads=16 -s stereo.default --alignment-method homography -t dg $in1.tif $in2.tif $in1.xml $in2.xml $dir/noproj --subpixel-mode 0

point2dem --nodata-value 0 $dir/noproj-PC.tif --orthoimage $dir/noproj-L.tif
ls -l $dir/noproj-DRG.tif $dir/noproj-DEM.tif $dir/noproj-PC.tif
show_dems.pl $dir/noproj-DEM.tif
# $gdt -scale 0 1000 0 255 -ot byte $dir/noproj1.tif $dir/noproj1-s.tif
# $gdt -scale 0 1000 0 255 -ot byte $dir/noproj2.tif $dir/noproj2-s.tif
