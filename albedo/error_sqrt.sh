#!/bin/bash

dir=/byss/docroot/albedo/AMCAM_0001/

cd $dir/data
mkdir -p ../error_sqrt

for f in $(ls -r *E.tif); do
    echo $f
    time_run.sh ~/bin/error_sqrt $f ../error_sqrt_tmp/$f
    time_run.sh gdal_translate  -co compress=none -co interleave=band ../error_sqrt_tmp/$f ../error_sqrt/$f
done
