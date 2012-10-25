#!/bin/bash

base=$HOME/projects/HiRISE/HiPrecision
#prefix=2010259
prefix=2010327
mfile=lroc_run_"$prefix".m
echo Will write $mfile
dir=$base/Data/lroc/Stereo_smd_2010_lists/Stereo_smd_"$prefix"_dir
cd $base

echo "path(path, '$base');" > $mfile
echo "cd  $dir"             >> $mfile

cat $dir/Stereo_smd_"$prefix".info.txt |grep -v ImageID | print_col.pl 1 7 8 6 | perl -pi -e "s#^(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s*\n#imageId='\$1'; rows=\$2; lineOffset=\$3; lineTime=\$4; resolveJitter4LROC_20101128(imageId, rows, lineOffset, lineTime);\n#g" >> $mfile