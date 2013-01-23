#!/bin/zsh

sub=$1
ratio=$2

for ((h = 0; h <= 5; h++)); do
    for ((w = 0; w <= 5; w++)); do
        ((startx=1024*w*4/sub))
        ((starty=1024*h*4/sub))
        ((wid=1024*4/sub))

        #qsub -q devel -N tile_"$w"_"$h"_"$sub" -l select=1:ncpus=8 -l walltime=0:01:00 -W group_list=s1219 -j oe -m e -- \
        qsub -N tile_"$w"_"$h"_"$sub" -l select=1:ncpus=8 -l walltime=10:00:00 -W group_list=s1219 -j oe -m e -- \
            $(pwd)/run19.sh $sub $startx $starty $wid $ratio $(pwd)
        #exit
        sleep 2
    done
done


