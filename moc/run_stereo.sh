#!/bin/zsh

if [ "$#" -lt 1 ]; then echo Usage: $0 mpp;  exit; fi

mpp=$1

a=M0100115.cub
b=E0201461.cub

. isis_setup.sh
echo machine is $(uname -n)

outDir="results_"$mpp"mpp"

rm -rfv ./$outDir
mkdir -p $outDir
res=$outDir/"res"

MM=3396.2 # mars radius in km
pi=3.1415926535897932384626433
((md=MM*2*pi*1000.0/360.0)) # meters per degree on mars
((spacing=mpp/md))
echo spacing is $spacing

time_run.sh stereo -s stereo_nomap.default --threads 16 $a $b $res
time_run.sh point2dem --dem-spacing $spacing --nodata-value -32767 --threads 1 -r mars $res-PC.tif
time_run.sh show_dems.pl $res-DEM.tif
time_run.sh remote_copy.pl $res-DEM.tif $L2

