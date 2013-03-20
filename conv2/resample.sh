#!/bin/bash


if [ "$#" -lt 1 ]; then echo Usage: $0 prefix pct; exit; fi

prefix=$1
pct=$2

((sub=100/pct))

time_run.sh ./dg_resample.py $prefix.xml $pct $prefix"_sub"$sub.xml
time_run.sh gdal_translate -outsize $pct% $pct% $prefix.tif $prefix"_sub"$sub.tif

grep -i -E "numrows|numcolumns" $prefix"_sub"$sub.xml
gdalinfo -stats $prefix"_sub"$sub.tif | grep -i size
