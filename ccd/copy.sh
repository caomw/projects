#!/bin/bash

# Copy a given directory from lou to pfe

if [ "$#" -lt 1 ]; then echo Usage: $0 dir; exit; fi
dir=$1

execdir=$(dirname $0)
echo execdir is $execdir
export PATH=$execdir:$HOME/bin:$HOME/projects/base_system/bin:$PATH
echo export PATH=$PATH

cd $dir

left=$(print_files.pl | awk '{print $1}')
right=$(print_files.pl | awk '{print $2}')
ssh $(whoami)@pfe25 "mkdir -p projects/data/stereo_antarctic/$dir"

rsync -avz $left.xml $right.xml $(whoami)@pfe25:projects/data/stereo_antarctic/$dir
rsync -avz $left.ntf $right.ntf $(whoami)@pfe25:projects/data/stereo_antarctic/$dir


