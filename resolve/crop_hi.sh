#!/bin/zsh

#if [ "$#" -lt 4 ]; then echo Usage: $0 wid hgt scale shift; exit; fi
#wid=$1
#hgt=$2
#scale=$3
#shifty=$4

wid=8500; hgt=1500; scale=0.5; shiftx=22000; shifty=11800

f=2
((wid=f*wid)); ((hgt=f*hgt))

t="x"

((wid=wid/scale))
((hgt=hgt/scale))
((shiftx=shiftx/scale))
((shifty=shifty/scale))

dir="res"$t"_"$wid"_"$hgt"_"$scale"_"$shiftx"_"$shifty

max_len=40000
if [ $wid -gt $max_len ]; then wid=$max_len; fi;
if [ $hgt -gt $max_len ]; then hgt=$max_len; fi;

mkdir -p $dir
res=$dir/res

. isis_setup.sh

left=results_1demMpp_1drgMpp_M139939938LE_M139946735RE/M139939938LE_rc_sc_map.cub
right=results_1demMpp_1drgMpp_M139939938LE_M139946735RE/M139946735RE_rc_sc_map.cub

left_scale=scale$scale-left.cub
right_scale=scale$scale-right.cub
if [ $scale -eq 1 ]; then
    left_scale=$left;
    right_scale=$right;
fi

if [ ! -e $left_scale ]; then reduce FROM = $left TO = $left_scale sscale=$scale lscale=$scale; fi
if [ ! -e $right_scale ]; then reduce FROM = $right TO = $right_scale sscale=$scale lscale=$scale; fi

left_crop=$res-crop-left.cub
right_crop=$res-crop-right.cub

((shifty_r=shifty+1500/scale))
crop f=$left_scale  t=$left_crop  samp=$shiftx line=$shifty   nsamp=$wid nline=$hgt
crop f=$right_scale t=$right_crop samp=$shiftx line=$shifty_r nsamp=$wid nline=$hgt

echo $left_crop $right_crop

left_tif=${left_crop/.cub/.tif}
right_tif=${right_crop/.cub/.tif}

gdal_translate -of GTiff -ot byte -scale 0 0.07 0 255 $left_crop  $left_tif 
image2qtree.pl $left_tif

gdal_translate -of GTiff -ot byte -scale 0 0.07 0 255 $right_crop  $right_tif 
image2qtree.pl $right_tif

time_run.sh stereo $left_crop $right_crop $res --threads 16 --stereo-file stereo.default
time_run.sh point2dem --nodata-value -32767 --threads 1 -r moon $res-PC.tif
time_run.sh show_dems.pl $res-DEM.tif
time_run.sh remote_copy.pl $res-DEM.tif $L2

gdalinfo -stats $left_crop |grep -i size
gdalinfo -stats $right_crop |grep -i size

echo Scale are $left_scale $right_scale

