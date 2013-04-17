#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

mpp=0.5
ls W*tif |grep -v ortho |grep -v quart | parallel rpc_mapproject --tr $mpp \
    --t_srs \""$opt"\" krigged_dem_nsidc_ndv0_fill.tif {} {.}.xml {.}"_ortho$mpp"m.tif


#for f in 10200100104A0300 1020010011862E00; do
#     rpc_mapproject --tr $mpp --t_srs "$opt" krigged_dem_nsidc_ndv0_fill.tif \
#         $f.tif $f.xml $f"_ortho$mpp".tif
# done
