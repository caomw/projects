#!/bin/bash

export SAMPLE=5;
dir=run2

cam1=WV01_11JUN171531433-P1BS-102001001549B500.xml
cam2=WV01_11JUN171532408-P1BS-1020010014597A00.xml

rm -f $dir/res-D_sub.tif

time_run.sh stereo_corr map/img1.tif map/img2.tif $cam1 $cam2 $dir/res gimpdem_90m.tiled.tif --session-type dg --threads 16 --stereo-file stereo.default  --corr-seed-mode 2 --disparity-estimation-dem map/res-DEM.tif --disparity-estimation-dem-error 1
