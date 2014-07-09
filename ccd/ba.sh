#!/bin/bash

# Do bundle adjustment and stereo on a stereo pair in given directory

set -x verbose

execdir=$(dirname $0)
echo execdir is $execdir
export PATH=$execdir:$HOME/bin:$HOME/projects/base_system/bin:$PATH

# \rm -rfv left* right* run*
export PATH=$HOME/projects/ccd:$PATH

left=$(print_files.pl | awk '{print $1}')
right=$(print_files.pl | awk '{print $2}')
ln -s $left.ntf left.tif; ln -s $left.xml left.xml
ln -s $right.ntf right.tif; ln -s $right.xml right.xml

# # which gdal_translate

gdal_translate.pl -srcwin 0 0 20000 20000 left.tif left_crop.tif  
gdal_translate.pl -srcwin 0 0 20000 20000 right.tif right_crop.tif  


# stereo left_crop.tif right_crop.tif left.xml right.xml run_noadjust/run --corr-timeout 300

bundle_adjust left_crop.tif right_crop.tif left.xml right.xml -o run_ba_ce/run  --bundle-adjuster ceres
\rm -rfv run_adjust_ce
\cp -rfv run_noadjust run_adjust_ce
stereo_tri left_crop.tif right_crop.tif left.xml right.xml run_adjust_ce/run --bundle-adjust-prefix run_ba_ce/run --corr-timeout 300

bundle_adjust left_crop.tif right_crop.tif left.xml right.xml -o run_ba_rs/run  --bundle-adjuster robustsparse
\rm -rfv run_adjust_rs
\cp -rfv run_noadjust run_adjust_rs
stereo_tri left_crop.tif right_crop.tif left.xml right.xml run_adjust_rs/run --bundle-adjust-prefix run_ba_rs/run --corr-timeout 300

ls */*PC.tif | $HOME/projects/base_system/bin/parallel "gdalinfo -stats {}"
#gdalinfo -stats run_noadjust/run-PC.tif &
#gdalinfo -stats run_adjust_ce/run-PC.tif &
#gdalinfo -stats run_adjust_rs/run-PC.tif &

point2dem  -r earth --nodata-value -32768 run_adjust_ce/run-PC.tif --errorimage
gdal_translate.pl -outsize 10% 10% run_adjust_ce/run-DEM.tif run_adjust_ce/run-DEM_10pct.tif

# show_dems.pl $(basename $(pwd))"_adjust" run_adjust/run-DEM_10pct.tif

# \rm -rf run_noadjust
# \cp -rf run_adjust run_noadjust
# gdalinfo -stats run_noadjust/run-PC.tif

# stereo_tri left_crop.tif right.tif left.xml right.xml run_noadjust/run 
# gdal_translate.pl -outsize 10% 10% run_noadjust/run-DEM.tif run_noadjust/run-DEM_10pct.tif
# show_dems.pl $(basename $(pwd))"_noadjust" run_noadjust/run-DEM_10pct.tif

# gdalinfo -stats run_noadjust/run-PC.tif
