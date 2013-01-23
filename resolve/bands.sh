#!/bin/bash


if [ "$#" -lt 2 ]; then echo Usage: $0 fileName sigmaFactor; exit; fi


inFile=$1
sigmaFactor=$2
#scale=$3

for band in 1 2 3; do 
#for band in 1; do 

    outFile=${inFile/.tif/}

    #outFile=$outFile"_band"$band"_"$scale"pct".tif
    #cmd="gdal_translate -b $band -outsize $scale"%" $scale"%" $inFile $outFile"

    outFile=$outFile"_band"$band.tif
    cmd="gdal_translate -b $band $inFile $outFile"

    echo $cmd;
    $cmd >/dev/null;
    
    cmd="float2colormap.pl $outFile $sigmaFactor"
    echo $cmd
    $cmd

    echo " "
done