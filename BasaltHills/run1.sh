#!/bin/sh

if [ "$#" -lt 3 ]; then echo Usage: $0 tag wid ifCorrect;  exit; fi
#if [ "$#" -lt 1 ]; then echo Usage: $0 tag ifCorrect;  exit; fi

t=$1
p=$2
c=$3

#p=300
#c=1 # 0 means no correction of velocity aberration

ssx=14500 # increase go left
ssy=2500 # increse go up 

echo Options are $t $p $c

if [ "$c" -eq "0" ]; then 
    opt="--disable-correct-velocity-aberration"
    t="$t"wid"$p"nCorr
else
    opt=""
    t="$t"wid"$p"yCorr
fi

tif1=09OCT11191503-P1BS_R1C1-052783426010_01_P001.rpc.TIF
cam1=09OCT11191503-P1BS_R1C1-052783426010_01_P001.XML
tif2=09OCT11191555-P1BS_R1C1-052783426010_01_P001.rpc.TIF
cam2=09OCT11191555-P1BS_R1C1-052783426010_01_P001.XML

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$PATH
gdt=$HOME/projects/base_system/bin/gdal_translate

wd=$p; ht=$p;
#a=$(echo $t | perl -pi -e "s#x.*?\$##g"); ((a=a*wd));
#b=$(echo $t | perl -pi -e "s#^.*?x##g"); ((b=b*ht));
#echo Doing window starting at x=$a and y=$b

#a=34029; b=9305; c=30472; d=1002; wd=1401; ht=1401;
a=10000; b=16800; c=14800; d=23000;# wd=$wid; ht=$wid;


((s1=-2700-18000-2000-1000+ssx)); ((s2=-1250-3000-2000-500+ssy));
#((s1=-2700-18000-2000-1000)); ((s2=-1250-3000-2000+100));
((a=a-s1)); ((b=b-s2)); ((c=c-s1)); ((d=d-s2));

#ht_shift=1400; ((b=b+ht_shift)); ((d=d+ht_shift));

((wd1=wd)); ((ht1=ht)); ((wd2=wd)); ((ht2=ht));

((a=a-wd1/2)); ((b=b-ht1/2)); ((c=c-wd2/2)); ((d=d-ht2/2)); # rm this!

#c=1; d=1;
#((wd2=10000)); ((ht2=10000));

if [[ $a -lt 1 ]]; then a=1; fi; ((aa=a+wd1)); if [[ $aa -gt 38456 ]]; then ((wd1=38456-a)); fi
if [[ $b -lt 1 ]]; then b=1; fi; ((bb=b+ht1)); if [[ $bb -gt 30477 ]]; then ((ht1=30477-b)); fi
if [[ $c -lt 1 ]]; then c=1; fi; ((cc=c+wd2)); if [[ $cc -gt 47700 ]]; then ((wd2=47700-c)); fi
if [[ $d -lt 1 ]]; then d=1; fi; ((dd=d+ht2)); if [[ $dd -gt 39487 ]]; then ((ht2=39487-d)); fi

echo ""
echo "--------------"
echo origin is $a $b $c $d
echo Widths $wd1 $ht1 $wd2 $ht2
echo ""
echo ""
# q1="$cam1"; qq1=$(echo $q1 | perl -pi -e "s#[-\.]#_#g");
# q2="$cam2"; qq2=$(echo $q2 | perl -pi -e "s#[-\.]#_#g");
#echo $a $b; echo $a $b > $qq1; echo $c $d; echo $c $d > $qq2
#echo 1 1 > $qq1; echo 1 1 > $qq2;

rm -rfv res$t; mkdir res$t

pic1=res$t/pic1.tif; pic1s=res$t/pic1s.tif
pic2=res$t/pic2.tif; pic2s=res$t/pic2s.tif
echo files are $pic1 $pic2
echo gdal_translate -srcwin $a $b $wd1 $ht1 $tif1 $pic1
echo gdal_translate -srcwin $c $d $wd2 $ht2 $tif2 $pic2
gdal_translate -srcwin $a $b $wd1 $ht1 $tif1 $pic1
gdal_translate -srcwin $c $d $wd2 $ht2 $tif2 $pic2

gdal_translate -scale 0 500 0 256 -ot byte -outsize 100% 100% $pic1 $pic1s
gdal_translate -scale 0 500 0 256 -ot byte -outsize 100% 100% $pic2 $pic2s
echo scaled pics: $pic1s $pic2s

echo " "
echo "---"
echo "stereo $pic1 $pic2 $cam1 $cam2 res$t/out filled_dem.tif --subpixel-mode 2 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --stereo-file stereo.default --disable-fill-holes --threads 16 $opt"
echo " "
echo " "
time stereo $pic1 $pic2 $cam1 $cam2 res$t/out filled_dem.tif --subpixel-mode 2 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --stereo-file stereo.default --disable-fill-holes --threads 16 $opt

# echo " "
# echo "---"
# echo "stereo $tif1 $tif2 $cam1 $cam2 res$t/out filled_dem.tif --subpixel-mode 2 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --stereo-file stereo.default --disable-fill-holes --threads 16 $opt"
# echo " "
# echo " "
# time stereo $tif1 $tif2 $cam1 $cam2 res$t/out filled_dem.tif --subpixel-mode 2 --subpixel-h-kernel 19 --subpixel-v-kernel 19 --stereo-file stereo.default --disable-fill-holes --threads 16 $opt

point2dem --nodata-value 0 res$t/out-PC.tif --orthoimage res$t/out-L.tif
ls -l res$t/out-DRG.tif res$t/out-DEM.tif res$t/out-PC.tif
show_dems.pl res$t/out-DEM.tif

echo ""
echo "Before correction"
geodiff res"$t"/out-DEM.tif zone10-CA_SanLuisResevoir-9m.tif -o res"$t"/out-diff"$p"
gdalinfo -stats res"$t"/out-diff"$p"-diff.tif |grep -n -i -E --colour=auto minimum | head -n 1

echo ""
echo "After correction"
dem_adjust res"$t"/out-DEM.tif -o res"$t"/out-DEM
geodiff res"$t"/out-DEM-adj.tif zone10-CA_SanLuisResevoir-9m.tif -o res"$t"/out-adj-diff"$p"
gdalinfo -stats res"$t"/out-adj-diff"$p"-diff.tif |grep -n -i -E --colour=auto minimum | head -n 1

#time ./convert_dem_to_pcd  res"$t"/out-DEM.tif res"$t"/out-DEM.