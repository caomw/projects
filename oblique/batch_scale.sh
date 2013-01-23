#!/bin/bash

if [ "$#" -lt 3 ]; then 
    echo Usage: $0 dirIn dirOut 4
    exit
fi

dirIn=$1
dirOut=$2
scaleFactor=$3

#PBS_NODEFILE="$currDir/machines.txt"
if [ "$PBS_NODEFILE"  != "" ]; then sshFileOption="--sshloginfile $PBS_NODEFILE"
else                                sshFileOption=""; fi

#rm -rfv $dirOut
#mkdir -p $dirOut 

# Make the paths absolute
currDir=$(pwd)
cd $dirOut; dirOut=$(pwd); cd $currDir
cd $dirIn;  dirIn=$(pwd);  cd $currDir

echo Scaling factor is $scaleFactor
cd $dirIn

. isis_setup.sh

ls *.cub | xargs -n 1 -P 1 -I {} reduce from={} to=$dirOut/{} sscale=$scaleFactor lscale=$scaleFactor

