#!/bin/sh


export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

dir=run2
rm -rfv $dir; mkdir $dir

cam1=WV01_11JUN171531433-P1BS-102001001549B500.xml
cam2=WV01_11JUN171532408-P1BS-1020010014597A00.xml
stereo map/img1.tif map/img2.tif $cam1 $cam2 $dir/res gimpdem_90m.tiled.tif --session-type dg --threads 16 --stereo-file stereo.default

time_run.sh point2dem --nodata-value 0 $dir/res-PC.tif --orthoimage $dir/res-L.tif
show_dems.pl $dir/res-DEM.tif
