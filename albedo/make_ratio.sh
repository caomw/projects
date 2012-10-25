#!/bin/bash

# Find the ratio of sizes of tifs from two directoris
dir1=DIM_input_640mpp
dir2=DIM_input_640mpp_masked

# Compare the DRG extracted from sub1 cubes with existing DRG
rm -f tmp_ans.txt
for f in $dir1/*tif; do
    g=$(echo $f | perl -pi -e "s#^.*?\/(AS\d+-M-\d+).*?\$#$dir2/\$1#g")
    g=$(ls "$g"*"tif" 2>/dev/null)
    if [ "$g" = "" ]; then echo "EROR: No file corresponding to $f in $dir2"; exit; fi
    sf=$(ls -l $f | ~/bin/print_col.pl 5)
    sg=$(ls -l $g | ~/bin/print_col.pl 5)
    ans=$(~/bin/ev $sf/$sg)
    #echo $f $sf $sg $ans
    echo $f $sf $sg $ans >> tmp_ans.txt
done
