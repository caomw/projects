#!/bin/bash

if [ "$#" -lt 2 ]; then 
    echo Usage: $0 albedoDir pattern
    exit
fi

albedoDir=$1; pattern=$2

files=$(ls $albedoDir/albedo/tile_"$pattern"*.tif 2>/dev/null)
if [ "$files" = "" ]; then exit; fi;

VISION_WORKBENCH_PATH=$HOME/visionworkbench/src/vw/tools
image2qtree="$VISION_WORKBENCH_PATH/image2qtree"

cmd="$VISION_WORKBENCH_PATH/image2qtree -m kml -o $albedoDir/kml/kml$pattern $files"
echo $cmd
$cmd

