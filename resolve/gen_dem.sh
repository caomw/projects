#!/bin/bash

i=0;

for f in $(cat list_dem.txt); do
    echo $f;
    ((i++));
    point2dem --threads 1 -r moon $f;
    g=$(echo $f | perl -pi -e "s#PC.tif#DEM.tif#g")
    show_dems.pl $g
done

