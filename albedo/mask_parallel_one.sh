#!/bin/bash

if [ "$#" -lt 3 ]; then 
    echo Usage: $0 imgFile maskDir outDir
    exit
fi
imgFile=$1
maskDir=$2
outDir=$3

# From DIM_input_640mpp/AS17-M-2596.tif get the value AS17-M-2596
maskPrefix=$(echo $imgFile | perl -pi -e "s#^.*?(AS\d\d.*?\d+).*?\$#\$1#g")
maskFile=$(ls $maskDir/$maskPrefix*tif 2>/dev/null)
if [ "$maskFile" = "" ] || [ ! -e "$maskFile" ]; then echo "ERROR: File $maskFile does not exist"; exit; fi

export DO_MASK=1
echo $HOME/StereoPipeline/src/asp/Tools/reconstruct $imgFile $maskFile $outDir
$HOME/StereoPipeline/src/asp/Tools/reconstruct $imgFile $maskFile $outDir
echo " "
echo " "
