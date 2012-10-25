#!/bin/bash

if [ "$#" -lt 3 ]; then 
    echo Usage: $0 dirIn dirOut 25%
    exit
fi

dirIn=$1
dirOut=$2
scaleFactor=$3

#PBS_NODEFILE="$currDir/machines.txt"
if [ "$PBS_NODEFILE"  != "" ]; then sshFileOption="--sshloginfile $PBS_NODEFILE"
else                                sshFileOption=""; fi

rm -rfv $dirOut
mkdir -p $dirOut 

# Make the paths absolute
currDir=$(pwd)
cd $dirOut; dirOut=$(pwd); cd $currDir
cd $dirIn;  dirIn=$(pwd);  cd $currDir

echo Scaling factor is $scaleFactor
scaleCmd="gdal_translate -co compress=lzw -outsize $scaleFactor $scaleFactor"
echo Scale command is $scaleCmd
cd $dirIn


#ls *.tif | parallel -P 4 -u $sshFileOption "cd $dirIn; echo Will do {}; $scaleCmd {} $dirOut/{}"
ls *.tif | xargs -n 1 -P 16 -I {} $scaleCmd {} $dirOut/{}
