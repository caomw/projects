#!/bin/bash

source ~/.bashenv

for p in DRG DEM DEMError; do 
    for dir in $(ls -d results_1mpp_*run4); do 
        remote_copy.pl $dir/LRONAC_"$p"_\*tif $L2
    done
done
