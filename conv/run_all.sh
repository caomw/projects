#!/bin/zsh

for ((h = 0; h <= 4; h++)); do
for ((w = 5; w >= 0; w--)); do
for l in 5 3 1; do 
    ((wid=6144*w))
    ((hgt=6144*h))
    #qsub -q devel -N tile_"$w"_"$h"_"$l" -l select=1:ncpus=8 -l walltime=0:01:00 -W group_list=s1219 -j oe -m e -- \
    qsub -N tile_"$w"_"$h"_"$l" -l select=1:ncpus=8 -l walltime=20:00:00 -W group_list=s1219 -j oe -m e -- \
        $(pwd)/run1.sh $l $wid $hgt $(pwd)
    sleep 5
done
done
done 


