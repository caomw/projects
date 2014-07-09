#!/bin/bash 

# Run stereo for given directory, for the purpose of finding
# and correcting CCD artifacts.

if [ "$#" -lt 1 ]; then echo Usage: $0 dir; exit; fi

source ~/.bashenv
dir=$1
if [ "$dir" != "" ]; then cd $dir; fi
T=$2
# y=$3
# p=$3
# s=$4
# r=$2

#crop="--left-image-crop-win 3072 3072 3072 3072"
crop="--left-image-crop-win 0 7168 50000 7168"
opts="--subpixel-mode 1 --corr-timeout 200 --disable-fill-holes --alignment-method homography --corr-max-levels 2"

basedir=$(dirname $(pwd))
$basedir/run_lr.sh $(pwd) $(basename $(pwd)) "$crop $opts" $T
