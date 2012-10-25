#!/bin/bash

base=$HOME/projects/HiRISE/HiPrecision
#prefix=2010259
prefix=2010327
shfile=lroc_run_"$prefix".sh
echo Will write $shfile
dir=$base/Data/lroc/Stereo_smd_2010_lists/Stereo_smd_"$prefix"_dir
cd $base

echo "cd  $dir" > $shfile

cat $dir/Stereo_smd_"$prefix".info.txt |grep -v ImageID | print_col.pl 1 7 8 6 | perl -pi -e "s#^(.*?)\s+(.*?)\s+(.*?)\s+(.*?)\s*\n#imageId='\$1'; rows=\$2; lineOffset=\$3; lineTime=\$4; ~/projects/HiRISE/HiPrecision/resolveJitter4LROC \\\$imageId \\\$rows \\\$lineOffset \\\$lineTime;\n#g" >> $shfile

chmod a+x $shfile