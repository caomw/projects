#!/bin/bash

if [ "$#" -lt 4 ]; then echo Usage: $0 pwd rev mpp pct; exit; fi

dir=$1
rev=$2
mpp=$3
pct=$4

if [ "$dir" != "" ]; then cd $dir; fi

source ~/.bashenv
export PATH=$HOME/projects/PhotometryTK/src/tools/:$PATH

ext=""
if [ "$pct" != "100" ]; then ext="_"$pct"pct"; fi

tag=rev"$rev"_"$mpp"mpp$ext

outFile=output_"$tag".txt
echo Will write to $outFile

exec &> $outFile 2>&1
list=dems_"$tag".txt
echo Writing $list

rm -f $list
touch $list
numSkipped=0
for f in  REV$rev*AS*/*DEM$ext"_grass".tif; do
    isBad=0;
    for g in $(cat bad.txt); do
        ans=$(echo $f | grep $g)
        if [ "$ans" != "" ]; then isBad=1; fi # skip bad DEMs
    done
    if [ "$isBad" -ne 0 ]; then
        echo Skipping $f
        ((numSkipped++))
        continue
    fi
    echo $f >> $list
done

echo Number of skipped: $numSkipped

set +x
~/bin/time_run.sh dem_mosaic -l $list --mpp "$mpp" -o dems_"$tag" --threads 4 --output-nodata-value -32767 --tile-size 1000000 --tile-index 0

