#!/bin/bash

dir=/byss/docroot/albedo/AMCAM_0001/

cd $dir/data
mkdir -p ../error_sqrt

for f in $(ls *A.tif); do
    g=$(echo $f | perl -pi -e "s#A\.tif#M.tif#g")
    time_run.sh gdal_translate -b 2 -co compress=none -co interleave=band $f ../error_sqrt/$g
done
