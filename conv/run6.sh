#!/bin/sh

sub=$1
level=$2
factor=$3
pth=$4

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi
if [ "$pth" != "" ]; then cd $pth; fi

source ~/.bashenv
export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

((pct=100/sub))
#25600 0
((wid=28672/sub))
#((wid=25600/sub))
hgt=0
dir=res_l$level_sub"$sub" # #"_"$wid"_"$hgt" _factor"$factor"_v11"

# exec &> output_"$dir".txt 2>&1

in1=WV02_10NOV261950171-P1BS-1030010008866100
in2=WV02_10NOV261951496-P1BS-103001000888E600

if [ $sub -ne 1 ]; then
    ./dg_resample.py $in1.tif $pct
    ./dg_resample.py $in2.tif $pct
    in1_sub=$in1"_sub"$sub
    in2_sub=$in2"_sub"$sub
else
    in1_sub=$in1
    in2_sub=$in2
fi

if [ $sub -eq 1 ]; then
    left=$in1.tif
    right=$in2.tif
else
    left=left_sub$sub.tif;
    if [ ! -e $left ]; then gdal_translate -outsize $pct% $pct% $in1.tif $left; fi
    right=right_sub$sub.tif;
    if [ ! -e $right ]; then gdal_translate -outsize $pct% $pct% $in2.tif $right; fi
fi

# for f in res-L.tif res-L_sub.tif res-R.tif res-R_sub.tif res-lMask.tif res-lMask_sub.tif \
#     res-rMask.tif res-rMask_sub.tif; do
#   if [ $sub -eq 1 ]; then
#       ln -s $(pwd)/res2/$f $(pwd)/$dir/$f
#   else
#       gdal_translate -outsize $pct% $pct% res2/$f $dir/$f
#   fi
# done

# sub1 range is -281 -348 336 158
a=-281;b=-348;c=336;d=158;
#((a=a/sub)); ((b=b/sub)); ((c=c/sub)); ((d=d/sub));
((a=factor*a/sub)); ((b=factor*b/sub)); ((c=factor*c/sub)); ((d=factor*d/sub));
seed="--corr-seed-mode 1"
#win="--left-image-crop-win $wid $hgt 1000 1000"
#win="--left-image-crop-win $wid $hgt 1000 1000 --corr-search -400 -400 400 400"
opts=" --corr-max-levels $level $seed $win --threads=16 -s stereo.default -t dg $left $right $in1_sub.xml $in2_sub.xml $dir/res --subpixel-mode 0 --disable-fill-holes --corr-search $a $b $c $d --alignment-method homography"
export DO_DUMP=1
rm -rfv $dir; mkdir -p $dir;
time_run.sh stereo_pprc $opts
time_run.sh stereo_corr $opts
time_run.sh stereo_rfne $opts
time_run.sh stereo_fltr $opts
time_run.sh stereo_tri  $opts
time_run.sh point2dem $dir/res-PC.tif
show_dems.pl $dir/res-DEM.tif
