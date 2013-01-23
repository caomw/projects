#!/bin/bash

. isis_setup.sh

a=M139939938LE
b=M139946735RE

t=parabola
res=results_"10mpp"_"$t"_85s_10w_"$a"_"$b"/"$a"_"$b"

cam2map from = 85s_10w/"$a".cal.cub to = 85s_10w/"$a".map.cal.10mpp.cub map = sp10mpp.map pixres=map
cam2map from = 85s_10w/"$b".cal.cub to = 85s_10w/"$b".map.cal.10mpp.cub map = sp10mpp.map pixres=map

time stereo -s stereo_"$t".default --threads 16 85s_10w/"$a".map.cal.10mpp.cub 85s_10w/"$b".map.cal.10mpp.cub $res
point2dem --nodata-value -32767 --threads 1 -r moon $res-PC.tif
show_dems.pl $res-DEM.tif