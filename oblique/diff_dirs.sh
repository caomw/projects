#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 dir1 dir2;  exit; fi

dir1=$1
dir2=$2

ls $dir1*/*DEM.tif | perl -pi -e "s#^.*?sub\d+\_##g" > tmp1.txt
ls $dir2*/*DEM.tif | perl -pi -e "s#^.*?sub\d+\_##g" > tmp2.txt

diff tmp1.txt tmp2.txt
rm -fv tmp1.txt tmp2.txt