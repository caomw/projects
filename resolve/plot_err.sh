#!/bin/bash

source ~/.bashenv

if [ "$#" -lt 1 ]; then echo Usage: $0 error.tif; exit; fi

err=$1
std=$2
if [ "$std" = "" ]; then std=0; fi
echo "std is $std"

band1_tmp=${err/.tif/tmp1.tif}; band1=${err/.tif/_North.tif};
time_run.sh gdal_translate -b 1 $err $band1_tmp; float2int2.pl $band1_tmp $band1 $std; rm -fv $band1_tmp
#remote_copy.pl $band1 $L2

band2_tmp=${err/.tif/tmp2.tif}; band2=${err/.tif/_East.tif};
time_run.sh gdal_translate -b 2 $err $band2_tmp; float2int2.pl $band2_tmp $band2 $std; rm -fv $band2_tmp
#remote_copy.pl $band2 $L2

band3_tmp=${err/.tif/tmp3.tif}; band3=${err/.tif/_Down.tif};
time_run.sh gdal_translate -b 3 $err $band3_tmp; float2int2.pl $band3_tmp $band3 $std; rm -fv $band3_tmp
#remote_copy.pl $band3 $L2
