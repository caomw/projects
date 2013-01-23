#!/bin/bash

. isis_setup.sh

a=M139939938LE
b=M139946735RE

t=integer
res=results_"$t"_85s_10w_"$a"_"$b"/"$a"_"$b"
time stereo -s stereo_"$t".default --threads 16 85s_10w/"$a".map.cub 85s_10w/"$b".map.cub $res
point2dem --nodata-value -32767 --threads 1 -r moon $res-PC.tif

t=parabola
res=results_"$t"_85s_10w_"$a"_"$b"/"$a"_"$b"
time stereo -s stereo_"$t".default --threads 16 85s_10w/"$a".map.cub 85s_10w/"$b".map.cub $res
point2dem --nodata-value -32767 --threads 1 -r moon $res-PC.tif
