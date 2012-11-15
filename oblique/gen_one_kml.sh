#!/bin/zsh

f=$1

((g=$f+1))

echo $f $g

if [ $g -lt 1000 ]; then 
  dir=run4_sub4_25deg_"$f"_0"$g"
else
  dir=run4_sub4_25deg_"$f"_"$g"
fi

show_dems.pl $dir/img-DEM.tif


