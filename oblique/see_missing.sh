#!/bin/bash


for f in data/res-25deg-sub16-*; do
    if [ -e $f/img-DEM.tif ]; then continue; fi
    out=$(echo $f | perl -pi -e "s#^.*?res-(.*?)\$#output-\$1.txt#g")
    echo $out
    files=$(cat $out |grep stereo | head -n 1 | perl -pi -e "s#^.*? (.*? .*?) .*?\n#\$1\n#g")
    echo "echo $files"
    echo "qview $files"
    echo " "
done