#!/bin/sh

if [ "$#" -lt 3 ]; then 
    echo Usage: $0 session ls tag
    exit
fi

s=$1
ls=$2 # lsq or nolsq
tag=$3

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH

t=$s"_"$ls"_"$tag # tag

in1=WV01_11JUN171531433-P1BS-102001001549B500
in2=WV01_11JUN171532408-P1BS-1020010014597A00
std=stereo_homography"_"$ls.default
opt="+proj=stere +lat_0=90 +lat_ts=70 +lon_0=-45 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
dem=gimpdem_90m.tiled.tif

gdt=$HOME/projects/base_system/bin/gdal_translate

sx1=16;
sy1=6;
sx2=13; # add to go right
sy2=8;  # add to move down
((a=34029-sx1)); ((b=9305-sy1)); ((c=30472-sx2)); ((d=1002-sy2));
wd=1401; ht=1401;
ht_shift=1400;
((b=b+ht_shift)); ((d=d+ht_shift));

((wd1=wd)); ((ht1=ht)); ((wd2=wd)); ((ht2=ht));
((a=a-wd/2)); ((b=b-ht/2)); ((c=c-wd/2)); ((d=d-ht/2));

if [[ $a -lt 1 ]]; then a=1; fi; ((aa=a+wd1)); if [[ $aa -gt 35840 ]]; then ((wd1=35840-a)); fi
if [[ $b -lt 1 ]]; then b=1; fi; ((bb=b+ht1)); if [[ $bb -gt 31744 ]]; then ((ht1=31744-b)); fi
if [[ $c -lt 1 ]]; then c=1; fi; ((cc=c+wd2)); if [[ $cc -gt 35840 ]]; then ((wd2=35840-c)); fi
if [[ $d -lt 1 ]]; then d=1; fi; ((dd=d+ht2)); if [[ $dd -gt 18432 ]]; then ((ht2=18432-d)); fi

echo Widths $wd1 $ht1 $wd2 $ht2
q1="$in1.xml"; qq1=$(echo $q1 | perl -pi -e "s#[-\.]#_#g");
echo $a $b;
echo $a $b > $qq1
q2="$in2.xml"; qq2=$(echo $q2 | perl -pi -e "s#[-\.]#_#g");
echo $c $d
echo $c $d > $qq2

rm -rfv res$t; mkdir res$t

pic1=pic1.tif; pic1s=pic1_s.tif
pic2=pic2.tif; pic2s=pic2_s.tif
echo files are $pic1 $pic2
echo gdal_translate -srcwin $a $b $wd1 $ht1 $in1.tif $pic1
echo gdal_translate -srcwin $c $d $wd2 $ht2 $in2.tif $pic2
gdal_translate -srcwin $a $b $wd1 $ht1 $in1.tif $pic1
gdal_translate -srcwin $c $d $wd2 $ht2 $in2.tif $pic2

gdal_translate -scale 0 1000 0 256 -ot byte -outsize 100% 100% $pic1 $pic1s
gdal_translate -scale 0 1000 0 256 -ot byte -outsize 100% 100% $pic2 $pic2s
echo scaled pics: $pic1s $pic2s

# DG stereo
echo "\nstereo --threads=16 -s $std -t $s $pic1 $pic2 $in1.xml $in2.xml res$t/noproj\n"
time stereo --threads=16 -s $std -t $s $pic1 $pic2 $in1.xml $in2.xml res$t/noproj

# Pinhole stereo
#echo "\nstereo --threads=16 -s $std -t pinhole $pic1 $pic2 cam1.pinhole cam2.pinhole res$t/noproj\n"
#time stereo --threads=16 -s $std -t pinhole $pic1 $pic2 cam1.pinhole cam2.pinhole res$t/noproj

point2dem --nodata-value 0 res$t/noproj-PC.tif --orthoimage res$t/noproj-L.tif
ls -l res$t/noproj-DRG.tif res$t/noproj-DEM.tif res$t/noproj-PC.tif
show_dems.pl res$t/noproj-DEM.tif
