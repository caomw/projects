#!/bin/bash

# Copy a given directory from lou to pfe

if [ "$#" -lt 1 ]; then echo Usage: $0 dir; exit; fi

startdir=$(pwd)

dir=$1
if [ ! -d "$dir" ]; then echo Missing directory $dir; exit; fi

# Make the dir absolute
cd $dir; dir=$(pwd)

# Path to the directory containing this script
cd $startdir
execdir=$(dirname $0)
cd $execdir
execdir=$(pwd)
export PATH=$execdir:$HOME/bin:$HOME/projects/base_system/bin:$PATH

cd $dir

echo "---- Starting at $(date) on $dir"

left=$(print_files.pl | awk '{print $1}')
right=$(print_files.pl | awk '{print $2}')
dir=$(basename $dir)
dir="$dir/"

destdir=/nobackupnfs2/$(whoami)/projects/data/stereo_antarctic/$dir
mkdir -p $destdir
for f in $left.xml $right.xml $left.ntf $right.ntf; do

    if [ ! -f "$f" ]; then
        echo Could not find $f, skipping
        continue
    fi
    
    if [ -f "$destdir/$f" ]; then
        echo $f exists, skipping
        continue
    fi
    echo Copy $f to $destdir
    shiftc $f $destdir
    sleep 2
done

# rsync -avz $left.xml $right.xml $(whoami)@pfe25:projects/data/stereo_antarctic/$dir

# shiftc --status $left.ntf $right.ntf /nobackupnfs2/$(whoami)/projects/data/stereo_antarctic/$dir

#rsync -avz $left.ntf $right.ntf $(whoami)@pfe25:projects/data/stereo_antarctic/$dir

