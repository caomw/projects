#!/bin/sh

source ~/.bashenv

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

# t=$s"_"$ls"_"$tag

in1=WV02_10NOV261950171-P1BS-1030010008866100
in2=WV02_10NOV261951496-P1BS-103001000888E600

level=$1
wid=$2
hgt=$3
pth=$4
if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi
if [ "$pth" != "" ]; then cd $pth; fi
    
dir=res_l$level"_"$wid"_"$hgt"_v2"

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

win="--left-image-crop-win $wid $hgt 6144 6144"
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
