#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 tag mpp;  exit; fi

i=$1
mpp=$2
t="$i"wid"$i"yCorr
#wid=$2

echo mpp is $mpp

#gdal_translate -srcwin 2800 4500 2000 1300 zone10-CA_SanLuisResevoir-9m.tif zone10-CA_SanLuisResevoir-9m_crop.tif 

#. ./makeall.sh

export LD_LIBRARY_PATH=/home/oalexan1/Downloads/PCL-1.6.0-Source/build/lib:/home/oalexan1/projects/base_system_341/lib 

#f1=res10000wid100000nCorr
#f2=res10000wid100000yCorr
f3=zone10-CA_SanLuisResevoir-9m_crop

#if [ ! -e "$f1$wid".pcd ] || [ ! -e "$f2$wid".pcd ] || [ ! -e "$f3".pcd ]; then
    #gdal_translate -srcwin 1 1 $wid $wid "$f1"/out-DEM.tif "$f1"/out-DEM_crop$wid.tif
    #gdal_translate -srcwin 1 1 $wid $wid "$f2"/out-DEM.tif "$f2"/out-DEM_crop$wid.tif
    #show_dems.pl "$f1"/out-DEM_crop$wid.tif &
    #show_dems.pl "$f2"/out-DEM_crop$wid.tif &
    #time ./convert_dem_to_pcd "$f1"/out-DEM_crop$wid.tif "$f1$wid".pcd
    #time ./convert_dem_to_pcd "$f2"/out-DEM_crop$wid.tif "$f2$wid".pcd
    #time ./convert_dem_to_pcd "$f3".tif "$f3".pcd
#fi

echo ""
echo "Before correction"
geodiff res"$t"/out-DEM.tif zone10-CA_SanLuisResevoir-9m.tif -o res"$t"/out-diff"$p"
gdalinfo -stats res"$t"/out-diff"$p"-diff.tif |grep -n -i -E --colour=auto minimum | head -n 1

echo ""
echo "After correction"
dem_adjust res"$t"/out-DEM.tif -o res"$t"/out-DEM
geodiff res"$t"/out-DEM-adj.tif zone10-CA_SanLuisResevoir-9m.tif -o res"$t"/out-adj-diff"$p"
gdalinfo -stats res"$t"/out-adj-diff"$p"-diff.tif |grep -n -i -E --colour=auto minimum | head -n 1

time ./convert_dem_to_pcd res"$t"/out-DEM.tif res"$t"/out-DEM.pcd   
time ./convert_dem_to_pcd res"$t"/out-DEM-adj.tif res"$t"/out-DEM-adj.pcd
time ./convert_dem_to_pcd "$f3".tif res"$t"/"$f3".pcd

#time ./pcl_random_subsample "$f1$wid".pcd "$f1$wid"_sub.pcd $mpp
#time ./pcl_random_subsample "$f2$wid".pcd "$f2$wid"_sub.pcd $mpp
#time ./pcl_random_subsample "$f3".pcd "$f3"_sub.pcd $mpp
time ./pcl_random_subsample  res"$t"/out-DEM.pcd res"$t"/out-DEM-sub.pcd $mpp
time ./pcl_random_subsample  res"$t"/out-DEM-adj.pcd res"$t"/out-DEM-adj-sub.pcd $mpp
time ./pcl_random_subsample  res"$t"/"$f3".pcd res"$t"/"$f3"_sub.pcd $mpp

#time ./pcl_icp_align "$f1$wid"_sub.pcd "$f2$wid"_sub.pcd
#time ./pcl_icp_align "$f1$wid"_sub.pcd "$f3"_sub.pcd 
#time ./pcl_icp_align "$f2$wid"_sub.pcd "$f3"_sub.pcd 
time ./pcl_icp_align res"$t"/out-DEM-sub.pcd res"$t"/"$f3"_sub.pcd
time ./pcl_icp_align res"$t"/out-DEM-adj-sub.pcd res"$t"/"$f3"_sub.pcd

