#!/bin/bash

# Usage: progName prefix files

prefix=$1
shift

for f in $*; do
    g=$(echo $f | perl -pi -e "s#^.*\/##g" |  perl -pi -e "s#\..*?\$##g")
    g=$prefix"_"$g
    echo $g
    image2qtree.pl $g $f 
done

