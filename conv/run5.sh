#!/bin/sh

# if [ "$#" -lt 3 ]; then 
#     echo Usage: $0 session ls tag
#     exit
# fi

# s=$1
# ls=$2 # or nolsq
# tag=$3

source ~/.bashenv

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

# t=$s"_"$ls"_"$tag

#in1=WV01_11JUN171531433-P1BS-102001001549B500
#in2=WV01_11JUN171532408-P1BS-1020010014597A00
in1=WV02_10NOV261950171-P1BS-1030010008866100
in2=WV02_10NOV261951496-P1BS-103001000888E600

#opt="+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
#dem=gimpdem_90m.tiled.tif

# mpp=1
# gdt=$HOME/projects/base_system/bin/gdal_translate

# rm -rfv res$t; mkdir res$t

# # Stereo of non-map-projected images
# std=stereo_homography"_"$ls.default
#time stereo --threads=16 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml res1/res
#time stereo_corr --threads=16 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml res1/res
#time stereo_corr --left-image-crop-win 20000 20000 600 600 --threads=1 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml res1/res
#time stereo_corr --left-image-crop-win 26000 0 100000 14000 --threads=16 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml res2/res
# time stereo_corr --left-image-crop-win 25600 0 1024 10240 --threads=16 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml res2/res
#time stereo_corr --left-image-crop-win 33830 3600 100 100 --threads=16 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml res2/res

level=5
wid=0
hgt=18432
((hgt=hgt+1024))
pth=$HOME/projects/conv

#level=$1
#wid=$2
#hgt=$3
#pth=$4
if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi
if [ "$pth" != "" ]; then cd $pth; fi
    
dir=res_l$level"_"$wid"_"$hgt"_v5"

echo will output to output_"$dir".txt
exec &> output_"$dir".txt 2>&1

echo Will run

mkdir -p $dir; cd $dir; for f in ../res2/*; do ln -s $f .; done; cd ..;

if [ "$level" -eq 0 ]; then
    seed=""
    level=5
else
    seed="--corr-seed-mode 0"
fi

#rm -rfv $dir; cp -rfv res2 $dir

win="--left-image-crop-win $wid $hgt 1024 1024 --corr-search -1200 -1400 1500 1000"
#win="--left-image-crop-win 25600 0 100 100"
opts="--corr-max-levels $level $seed $win --threads=16 -s stereo.default -t dg $in1.tif $in2.tif $in1.xml $in2.xml $dir/res"
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem $dir/res-PC.tif
#show_dems.pl $dir/res-DEM.tif 

# point2dem --nodata-value 0 res$t/noproj-PC.tif --orthoimage res$t/noproj-L.tif
# ls -l res$t/noproj-DRG.tif res$t/noproj-DEM.tif res$t/noproj-PC.tif
# show_dems.pl res$t/noproj-DEM.tif
