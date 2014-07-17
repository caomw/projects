#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 dir tdi; exit; fi

# List all dirs in given dir having given tdi
dir=$1
tdi=$2

for d in $(ls -d $dir/WV01* 2>/dev/null); do
    if [ ! -d "$d" ]; then continue; fi
    file=$(ls $d/*xml | head -n 1)
    if [ "$file" = "" ]; then continue; fi
    if [ ! -f "$file" ]; then continue; fi

    #echo $file
    f=$(grep TDILEVEL\>$tdi\< $file)
    if [ "$f" = "" ]; then continue; fi
    echo $d

    #rsync -avz $d oalexan1@pfe25:projects/data/stereo_antarctic/ \
    #    --include '*/' --include '*/*.jpg' --include '*/*xml' --exclude '*'
done