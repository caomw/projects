#!/bin/bash

if [ "$#" -lt 2 ]; then 
    echo Usage: $0 dirIn dirOut
    exit
fi

dirIn=$1
dirOut=$2

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
#scaleCmd="gdal_translate  -scale 0 1000 0 999"
scaleCmd="gdal_translate"
#scaleCmd="gdal_translate -b 1 -ot byte -outsize 10% 10% -scale 0 1000 0 500"
#scaleCmd="gdal_translate -b 1 -ot byte -outsize 10% 10% -scale 0 1000 0 999"
echo Scale command is $scaleCmd
cd $dirIn


#ls *.tif | parallel -P 4 -u $sshFileOption "cd $dirIn; echo Will do {}; $scaleCmd {} $dirOut/{}"
ls *.tif | xargs -n 1 -P 8 -I {} $scaleCmd {} $dirOut/{} > /dev/null 2>&1
