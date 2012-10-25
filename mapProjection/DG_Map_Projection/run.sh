#!/bin/sh

if [ "$#" -lt 3 ]; then 
    echo Usage: $0 session ls tag
    exit
fi

s=$1
ls=$2 # or nolsq
tag=$3

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

w=1000
t=$s"_"$ls"_"$tag

c=-175000; d=-2331000; ((a=c-w)); ((b=d-w));
# st=10000
# #((c=-195121+st)); ((d=-2345110+st))
# ((c=-168942-st)); ((d=-2329383-st))
# echo $c $d
# #c=-180000; d=-2339000; 
# ((a=c-w)); ((b=d-w));

in1=WV01_11JUN171531433-P1BS-102001001549B500
in2=WV01_11JUN171532408-P1BS-1020010014597A00
opt="+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
dem=gimpdem_90m.tiled.tif

mpp=1
out=output_"$t".txt
gdt=$HOME/projects/base_system/bin/gdal_translate

rm -rfv res$t; mkdir res$t

#gdal_translate -srcwin 0 0 7000 20000 WV01_11JUN171531433-P1BS-102001001549B500.tif pic1.tif
#rpc_mapproject --tr $mpp --t_srs "$opt" $dem pic1.tif $in1.xml res$t/proj1_1.tif
#gdal_translate -scale 0 1000 0 256 -ot byte -outsize 10% 10% res$t/proj1_1.tif res$t/proj1_1_s.tif
#image2qtree.pl res$t/proj1_1_s.tif

#gdal_translate -srcwin 0 0 8000 5000 $in2.tif pic2.tif
#rpc_mapproject --tr $mpp --t_srs "$opt" $dem pic2.tif $in2.xml res$t/proj2_1.tif
#gdal_translate -scale 0 1000 0 256 -ot byte -outsize 10% 10% res$t/proj2_1.tif res$t/proj2_1_s.tif
#image2qtree.pl res$t/proj2_1_s.tif

#std=stereo_homography"_"$ls.default
#time stereo --threads=16 -s $std -t $s pic1.tif pic2.tif $in1.xml $in2.xml res$t/noproj # $dem
# point2dem --nodata-value 0 res$t/noproj-PC.tif --orthoimage res$t/noproj-L.tif
# ls -l res$t/noproj-DRG.tif res$t/noproj-DEM.tif res$t/noproj-PC.tif
# show_dems.pl cut1 res$t/noproj-DEM.tif
# # $gdt -scale 0 1000 0 255 -ot byte res$t/noproj1.tif res$t/noproj1-s.tif
# # $gdt -scale 0 1000 0 255 -ot byte res$t/noproj2.tif res$t/noproj2-s.tif

# Stereo of map-projected cropped images
rpc_mapproject --t_projwin $a $b $c $d --tr $mpp --t_srs "$opt" $dem $in1.tif $in1.xml res$t/projw1.tif
rpc_mapproject --t_projwin $a $b $c $d --tr $mpp --t_srs "$opt" $dem $in2.tif $in2.xml res$t/projw2.tif
std=stereo_nohomography"_"$ls.default
time stereo --threads=16 -s $std -t $s res$t/projw1.tif res$t/projw2.tif $in1.xml $in2.xml res$t/projw $dem

point2dem --nodata-value 0 res$t/projw-PC.tif --orthoimage res$t/projw-L.tif
ls -l res$t/projw-DRG.tif res$t/projw-DEM.tif res$t/projw-PC.tif
show_dems.pl res$t/projw-DEM.tif
$gdt -scale 0 1000 0 255 -ot byte res$t/projw1.tif res$t/projw1-s.tif
$gdt -scale 0 1000 0 255 -ot byte res$t/projw2.tif res$t/projw2-s.tif
#image2qtree.pl res$t/projw1-s.tif
#image2qtree.pl res$t/projw2-s.tif
# $gdt -scale 0 1 0 255 -ot byte res$t/projw-DRG.tif res$t/projw-DRG_s.tif 
# image2qtree.pl projw-DRG_s.tif

# Stereo of map-projected uncropped images
rpc_mapproject --tr $mpp --t_srs "$opt" $dem $in1.tif $in1.xml res$t/proj1.tif
rpc_mapproject --tr $mpp --t_srs "$opt" $dem $in2.tif $in2.xml res$t/proj2.tif
std=stereo_nohomography"_"$ls.default
time stereo --threads=16 -s $std -t $s res$t/proj1.tif res$t/proj2.tif $in1.xml $in2.xml res$t/proj $dem

point2dem --nodata-value 0 res$t/proj-PC.tif --orthoimage res$t/proj-L.tif
ls -l res$t/proj-DRG.tif res$t/proj-DEM.tif res$t/proj-PC.tif
show_dems.pl res$t/proj-DEM.tif
$gdt -scale 0 1000 0 255 -ot byte res$t/proj1.tif res$t/proj1-s.tif
$gdt -scale 0 1000 0 255 -ot byte res$t/proj2.tif res$t/proj2-s.tif
#image2qtree.pl res$t/proj1-s.tif
#image2qtree.pl res$t/proj2-s.tif
# $gdt -scale 0 1 0 255 -ot byte res$t/proj-DRG.tif res$t/proj-DRG_s.tif 
# image2qtree.pl proj-DRG_s.tif

# Stereo of non-map-projected images
std=stereo_homography"_"$ls.default
time stereo --threads=16 -s $std -t $s $in1.tif $in2.tif $in1.xml $in2.xml res$t/noproj # $dem

point2dem --nodata-value 0 res$t/noproj-PC.tif --orthoimage res$t/noproj-L.tif
ls -l res$t/noproj-DRG.tif res$t/noproj-DEM.tif res$t/noproj-PC.tif
show_dems.pl res$t/noproj-DEM.tif

# Crop
# $gdt -projwin -49.41 68.63 -49.35 68.605 proj_10mpp-DEM__proj_win-DEM-diff.tif proj_10mpp-DEM__proj_win-DEM-diff_cropped.tif
# rs proj_10mpp-DEM__proj_win-DEM-diff.tif $L2:$P
# de proj_10mpp-DEM__proj_win-DEM-diff.tif
# proj_10mpp-DEM__proj_win-DEM-diff_integer.tif
# $stereo -t $s proj1.tif proj2.tif $in1.xml $in2.xml proj/proj $dem

