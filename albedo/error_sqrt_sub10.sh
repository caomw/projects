#!/bin/bash

dir=/byss/docroot/albedo/AMCAM_0001/

cd $dir/error_sqrt
mkdir -p ../error_sqrt_sub10

for f in $(ls *E.tif); do
    echo $f
    time_run.sh gdal_translate -outsize 10% 10% -co compress=none -co interleave=band $f ../error_sqrt_sub10/$f
done
