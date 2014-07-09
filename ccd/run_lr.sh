#!/bin/bash

if [ "$#" -lt 3 ]; then echo Usage: $0 dir tag opts; exit; fi

# To do: Force that all runs be redone below!

# PATH to the ASP build compiled for merope.
source ~/.bashenv

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$HOME/projects/visionworkbench/src/vw/tools:$HOME/projects/base_system/bin:$HOME/projects/packages/bin:$HOME/bin:$PATH
# Path for merope
v=$(stereo_fltr 2>&1 |grep -i "bin/sed" | perl -pi -e "s#\s##g")
if [ "$v" != "" ]; then
    export PATH=$HOME/projects/StereoPipeline2/src/asp/Tools:$PATH
fi

execDir=$(dirname $0)

dir=$1
if [ "$dir" != "" ]; then cd $dir; fi

tag=$2
opts=$3
T=$4
# p=$5
# s=$6
tag2="$T"
#export T=$T

runDir="fixed"$tag2"$tag" # "_"$p"_"$s
outFile=output_"$runDir".txt
echo runDir=$runDir
echo Will write to $(pwd)/$outFile
exec &> $outFile 2>&1

l=$($execDir/print_files.pl | awk '{print $1}')
r=$($execDir/print_files.pl | awk '{print $2}')

if [[ ! $opts =~ left-image-crop-win ]]; then
    echo "Must specify crop-win as input"
    exit 1;
fi
win=$(echo $opts | perl -pi -e 's#^.*?left-image-crop-win\s+(\d+\s+\d+\s+\d+\s+\d+).*?$#$1#g')

#win2="0 0 7168 7168"  # temporary!!!
#win3="0 0 7168 7168"  # temporary!!!
win2="0 0 50600 21504"
win3="0 0 50600 21504"
#rm -fv *crop* *proj_crop*
if [ ! -f $l"_crop.tif" ]; then
    ~/bin/gdal_translate.pl -srcwin $win2 $l.ntf $l"_crop.tif"
fi

if [ ! -f $r"_crop.tif" ]; then
    ~/bin/gdal_translate.pl -srcwin $win3 $r.ntf $r"_crop.tif"
fi

# for fp in $l $r; do 
#     ~/bin/time_run.sh mapproject -t rpc --tr 20 ~/projects/StereoPipelineTest/data/krigged_dem_nsidc_ndv0_fill.tif $fp"_crop".tif $fp.xml $fp"_proj_crop".tif
#     ~/bin/time_run.sh ~/bin/float2int2.pl $fp"_proj_crop".tif
#     ~/bin/time_run.sh ~/bin/image2qtree.pl $tag$fp $fp"_proj_crop_int".tif
# done

turnon=0
hill=$runDir/run-crop-hill.tif
if [ "$turnon" -eq 1 ]; then
    rm -rfv $runDir
    mkdir -p $runDir

    wv_correct "$l"_crop.tif "$l".xml $runDir/"$l"_crop_shift.tif
    wv_correct "$r"_crop.tif "$r".xml $runDir/"$r"_crop_shift.tif
    
    ~/bin/time_run.sh stereo $runDir/"$l"_crop_shift.tif $runDir/"$r"_crop_shift.tif "$l".xml "$r".xml $runDir/run $opts
    gdal_translate.pl -srcwin $win $runDir/run-F.tif $runDir/run-crop-F.tif
    $execdir/find_avg_disp $runDir/run-crop-F.tif $runDir/dx.txt $runDir/dy.txt
    gdal_translate.pl -srcwin $win $runDir/run-PC.tif $runDir/run-crop-PC.tif 
    point2dem -r Earth  $runDir/run-crop-PC.tif 
    gdaldem hillshade   $runDir/run-crop-DEM.tif $hill
    gdal_translate -outsize 50% 50% $hill $runDir/run-crop-hill_sub2.tif
    ~/bin/image2qtree.pl $runDir/run-crop-hill_sub2.tif
    rm -fv $runDir/*[A-Z]*.tif
fi

turnon=1
runDir0=runv"$tag2""$tag"_flip0
hill=$runDir0/run-crop-hill.tif
if [ "$turnon" -eq 1 ]; then
    rm -rfv $runDir0
    ~/bin/time_run.sh stereo "$l"_crop.tif "$r"_crop.tif "$l".xml "$r".xml $runDir0/run $opts
    gdal_translate.pl -srcwin $win $runDir0/run-F.tif $runDir0/run-crop-F.tif
    $execdir/find_avg_disp $runDir0/run-crop-F.tif $runDir0/dx.txt $runDir0/dy.txt
    gdal_translate.pl -srcwin $win $runDir0/run-PC.tif $runDir0/run-crop-PC.tif 
    point2dem -r Earth  $runDir0/run-crop-PC.tif --errorimage 
    gdaldem hillshade   $runDir0/run-crop-DEM.tif $hill
    gdal_translate -outsize 50% 50% $hill $runDir0/run-crop-hill_sub2.tif
    ~/bin/image2qtree.pl $runDir0/run-crop-hill_sub2.tif
    rm -fv $(ls $runDir0/*{PC,RD}*.tif)
fi

turnon=1
runDir1=runv"$tag2""$tag"_flip1
hill=$runDir1/run-crop-hill.tif
if [ "$turnon" -eq 1 ]; then
    rm -rfv $runDir1
    ~/bin/time_run.sh stereo "$r"_crop.tif "$l"_crop.tif "$r".xml "$l".xml $runDir1/run $opts
    gdal_translate.pl -srcwin $win $runDir1/run-F.tif $runDir1/run-crop-F.tif
    $execdir/find_avg_disp $runDir1/run-crop-F.tif $runDir1/dx.txt $runDir1/dy.txt
    gdal_translate.pl -srcwin $win $runDir1/run-PC.tif $runDir1/run-crop-PC.tif 
    point2dem -r Earth  $runDir1/run-crop-PC.tif --errorimage
    gdaldem hillshade   $runDir1/run-crop-DEM.tif $hill
    gdal_translate -outsize 50% 50% $hill $runDir1/run-crop-hill_sub2.tif
    ~/bin/image2qtree.pl $runDir1/run-crop-hill_sub2.tif
    rm -fv $(ls $runDir1/*{PC,RD}*.tif)
fi

