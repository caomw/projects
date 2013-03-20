#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 dir; exit; fi

dir=$1
mkdir -p $dir
cd $dir
src=/u/zmoratto/nobackup/Earth/ZackSpecific/$dir

for suffix in $(ls $src/*ntf | perl -pi -e "s#^.*-(.*?)\.ntf#\$1#g" | unique.pl); do
    #echo suffix is $suffix
    dg_mosaic.py --reduce-percent=50 --output-prefix=$suffix $(ls $src/*$suffix.ntf) &
done
