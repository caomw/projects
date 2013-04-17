#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 sub; exit; fi
sub=$1
((pct=100/sub))

dir=res_sub"$sub"
rm -rfv $dir

img1=WV01_11JAN131652222-P1BS-10200100104A0300.r12.tif
cam1=WV01_11JAN131652222-P1BS-10200100104A0300.r12.xml
img2=WV01_11JAN131653180-P1BS-1020010011862E00.r12.tif
cam2=WV01_11JAN131653180-P1BS-1020010011862E00.r12.xml

if [ $sub -ne 1 ]; then
    # Must scale the cameras for map-projected images
    cam1_sub=${cam1/.xml/_sub$sub.xml}
    cam2_sub=${cam2/.xml/_sub$sub.xml}
    if [ ! -e $cam1_sub ]; then time_run.sh ./dg_resample.py $cam1 $pct $cam1_sub; fi
    if [ ! -e $cam2_sub ]; then time_run.sh ./dg_resample.py $cam2 $pct $cam2_sub; fi
    # Must not scale the cameras for map-projected images
    #cam1_sub=$cam1
    #cam2_sub=$cam2

    img1_sub=${img1/.tif/_sub$sub.tif}
    img2_sub=${img2/.tif/_sub$sub.tif}
    if [ ! -e $img1_sub ]; then time_run.sh gdal_translate -outsize $pct% $pct% $img1 $img1_sub; fi
    if [ ! -e $img2_sub ]; then time_run.sh gdal_translate -outsize $pct% $pct% $img2 $img2_sub; fi
else
    img1_sub=$img1
    img2_sub=$img2
    cam1_sub=$cam1
    cam2_sub=$cam2
fi

stereo $img1_sub $img2_sub $cam1_sub $cam2_sub $dir/res --session-type dg --stereo-file stereo.default --left-image-crop-win 2048 0 1024 1024 --corr-seed-mode 1 --alignment-method homography

#point2dem -r earth $dir/res-PC.tif $dir/res-DEM.tif
#show_dems.pl $dir/res-DEM.tif
