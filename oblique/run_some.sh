#!/bin/bash


a=0806
((b=a+1));
. isis_setup.sh
img=AS15-M-"$b".lev1.cub
dir=run3_sub4_25deg_"$a"_"$b"
if [ $a -lt 1000 ]; then img=AS15-M-0"$b".lev1.cub; dir=run3_sub4_25deg_"$a"_0"$b"; fi
~/bin/rsync.sh
stereo_tri sub4_cubes_25deg/AS15-M-"$a".lev1.cub sub4_cubes_25deg/$img $dir/img --cache-dir $dir/cache --stereo-file stereo.default
point2dem --threads 1 -r moon --nodata-value -32767 $dir/img-PC.tif -o $dir/img-v8
show_dems.pl $dir/img-v8-DEM.tif


a=1355
((b=a+1));
. isis_setup.sh
img=AS15-M-"$b".lev1.cub
dir=run3_sub4_25deg_"$a"_"$b"
if [ $a -lt 1000 ]; then img=AS15-M-0"$b".lev1.cub; dir=run3_sub4_25deg_"$a"_0"$b"; fi
~/bin/rsync.sh
stereo_tri sub4_cubes_25deg/AS15-M-"$a".lev1.cub sub4_cubes_25deg/$img $dir/img --cache-dir $dir/cache --stereo-file stereo.default
point2dem --threads 1 -r moon --nodata-value -32767 $dir/img-PC.tif -o $dir/img-v8
show_dems.pl $dir/img-v8-DEM.tif


