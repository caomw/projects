#!/bin/bash

file=$1
cmd=$(cat $file | grep stereo_pprc | perl -pi -e "s#^.*?pprc#stereo#g")

. isis_setup.sh

echo "Doing " $cmd
$cmd
