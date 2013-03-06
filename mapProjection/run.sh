#!/bin/sh


export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

w=1000
c=-175000; d=-2331000; ((a=c-w)); ((b=d-w));

in1=WV01_11JUN171531433-P1BS-102001001549B500
in2=WV01_11JUN171532408-P1BS-1020010014597A00
opt="+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
dem=gimpdem_90m.tiled.tif

mpp=1
gdt=$HOME/projects/base_system/bin/gdal_translate

dir=map
rm -rfv $dir; mkdir $dir

# Stereo of map-projected cropped images
rpc_mapproject --t_projwin $a $b $c $d --tr $mpp --t_srs "$opt" $dem $in1.tif $in1.xml $dir/img1.tif
rpc_mapproject --t_projwin $a $b $c $d --tr $mpp --t_srs "$opt" $dem $in2.tif $in2.xml $dir/img2.tif
time_run.sh stereo --threads=16 -s stereo.default -t dg $dir/img1.tif $dir/img2.tif $in1.xml $in2.xml $dir/res $dem

time_run.sh point2dem --nodata-value 0 $dir/res-PC.tif --orthoimage $dir/res-L.tif
ls -l $dir/res-DRG.tif $dir/res-DEM.tif $dir/res-PC.tif
show_dems.pl $dir/res-DEM.tif
#$gdt -scale 0 1000 0 255 -ot byte $dir/img1.tif $dir/img1-s.tif
#$gdt -scale 0 1000 0 255 -ot byte $dir/img2.tif $dir/img2-s.tif
