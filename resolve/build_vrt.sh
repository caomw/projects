#!/bin/bash

for dir in results_1mpp_M*run3; do

    pct=7
    ((sub=100/pct))
    prefix=${dir/results_1mpp_/}
    echo $prefix
    
    time_run.sh gdalbuildvrt -srcnodata 0 $prefix.tif $dir/LRONAC_DRG_*.tif
    time_run.sh gdal_translate -outsize $pct% $pct% $prefix.tif $prefix"_sub$sub.tif"
    time_run.sh image2qtree.pl $prefix"_sub$sub.tif"

done

# if [ "$#" -lt 1 ]; then echo Usage: $0 dir; exit; fi

# dir=$1
# file=${dir/results_1mpp_/}

# time_run.sh gdalbuildvrt $file.tif $dir/LRONAC_DRG_*tif
# time_run.sh gdal_translate -outsize  5% 5% $file.tif $file"_sub20".tif
# time_run.sh image2qtree.pl $file"_sub20".tif

