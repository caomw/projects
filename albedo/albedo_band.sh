#!/bin/bash

dir=/byss/docroot/albedo/AMCAM_0001/

cd $dir/data
mkdir -p ../error_sqrt

for f in $(ls *A.tif); do
    echo $f
    time_run.sh gdal_translate -b 1 -co compress=none -co interleave=band $f ../error_sqrt/$f
done
