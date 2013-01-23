#!/bin/bash


#if [ "$#" -lt 1 ]; then echo Usage: $0 dir; exit; fi
#dir=$1

#sleep 10000;
for dir in $(ls -d results_1mpp_*run3); do 
    remote_copy.pl $dir/LRONAC_*DRG_*tif $L2
    remote_copy.pl $dir/LRONAC_*hill*tif $L2
    remote_copy.pl $dir/LRONAC_*DEM_*tif $L2
    remote_copy.pl $dir/LRONAC_*DEMError_*tif $L2
done
