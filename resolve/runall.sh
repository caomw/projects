#!/bin/bash

d=85s_10w
l1=M139912793LE; l2=M139919591LE;
r1=M139912793RE; r2=M139919591RE;
c=.map.cub
t=.map.tif
in=oalexan1@lunokhod1:/home/anefian/projects/resolve/$d
. isis_setup.sh

stereo --threads 16 $d/$l1$c $d/$l2$c results"_"$d"_"$l1"_"$l2/$l1"_"$l2
stereo --threads 16 $d/$l1$c $d/$r2$c results"_"$d"_"$l1"_"$r2/$l1"_"$r2
stereo --threads 16 $d/$r1$c $d/$l2$c results"_"$d"_"$r1"_"$l2/$r1"_"$l2
stereo --threads 16 $d/$r1$c $d/$r2$c results"_"$d"_"$r1"_"$r2/$r1"_"$r2

nohup nice -19 stereo --threads 16 $d/$l1$c $d/$l2$c results_bayes"_"$d"_"$l1"_"$l2/$l1"_"$l2 > output_ll.txt 2>&1&
nohup nice -19 stereo --threads 16 $d/$l1$c $d/$r2$c results_bayes"_"$d"_"$l1"_"$r2/$l1"_"$r2 > output_lr.txt 2>&1&
nohup nice -19 stereo --threads 16 $d/$r1$c $d/$l2$c results_bayes"_"$d"_"$r1"_"$l2/$r1"_"$l2 > output_rl.txt 2>&1&
nohup nice -19 stereo --threads 16 $d/$r1$c $d/$r2$c results_bayes"_"$d"_"$r1"_"$r2/$r1"_"$r2 > output_rr.txt 2>&1&

remote_copy.pl results_bayes"_"$d"_"$l1"_"$l2/$l1"_"$l2-PC.tif $L2
remote_copy.pl results_bayes"_"$d"_"$l1"_"$r2/$l1"_"$r2-PC.tif $L2
remote_copy.pl results_bayes"_"$d"_"$r1"_"$l2/$r1"_"$l2-PC.tif $L2
remote_copy.pl results_bayes"_"$d"_"$r1"_"$r2/$r1"_"$r2-PC.tif $L2


point2dem -r moon results_bayes"_"$d"_"$l1"_"$l2/$l1"_"$l2-PC.tif
point2dem -r moon results_bayes"_"$d"_"$l1"_"$r2/$l1"_"$r2-PC.tif
point2dem -r moon results_bayes"_"$d"_"$r1"_"$l2/$r1"_"$l2-PC.tif
point2dem -r moon results_bayes"_"$d"_"$r1"_"$r2/$r1"_"$r2-PC.tif


gdalinfo -stats results_bayes"_"$d"_"$l1"_"$l2/$l1"_"$l2-DEM.tif
gdalinfo -stats results_bayes"_"$d"_"$l1"_"$r2/$l1"_"$r2-DEM.tif
gdalinfo -stats results_bayes"_"$d"_"$r1"_"$l2/$r1"_"$l2-DEM.tif
gdalinfo -stats results_bayes"_"$d"_"$r1"_"$r2/$r1"_"$r2-DEM.tif

echo results_bayes"_"$d"_"$l1"_"$l2/$l1"_"$l2-DEM.tif
echo results_bayes"_"$d"_"$l1"_"$r2/$l1"_"$r2-DEM.tif
echo results_bayes"_"$d"_"$r1"_"$l2/$r1"_"$l2-DEM.tif
echo results_bayes"_"$d"_"$r1"_"$r2/$r1"_"$r2-DEM.tif


show_dems.pl results_bayes"_"$d"_"$l1"_"$l2/$l1"_"$l2-DEM.tif
show_dems.pl results_bayes"_"$d"_"$l1"_"$r2/$l1"_"$r2-DEM.tif
show_dems.pl results_bayes"_"$d"_"$r1"_"$l2/$r1"_"$l2-DEM.tif
show_dems.pl results_bayes"_"$d"_"$r1"_"$r2/$r1"_"$r2-DEM.tif

rsync -avz $in/$l1$c $d
rsync -avz $in/$l2$c $d
rsync -avz $in/$r1$c $d
rsync -avz $in/$r2$c $d

gdal_translate -of GTiff $d/$l1$c $d/$l1$t; image2qtree.pl $d/$l1$t
gdal_translate -of GTiff $d/$l2$c $d/$l2$t; image2qtree.pl $d/$l2$t
gdal_translate -of GTiff $d/$r1$c $d/$r1$t; image2qtree.pl $d/$r1$t
gdal_translate -of GTiff $d/$r2$c $d/$r2$t; image2qtree.pl $d/$r2$t

