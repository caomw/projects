#!/bin/bash


#dem1.tif
#cub.cub

a=37
b=38

#good
#gdal_translate -srcwin 0   0 400 100 dem3.tif dem$a.tif
#gdal_translate -srcwin 200 0 200 100 dem3.tif dem$b.tif

#bad
gdal_translate -srcwin 0  0 400 100 dem3.tif dem$a.tif
gdal_translate -srcwin 3 41 257  82 dem3.tif dem$b.tif

. isis_setup.sh
orthoproject --threads 16 --mpp 32 dem$a.tif cub.cub drg$a.tif > output$a.txt 2>&1;

. isis_setup.sh
orthoproject --threads 16 --mpp 32 dem$b.tif cub.cub drg$b.tif > output$b.txt 2>&1;

show_dems.pl dem$a.tif
show_dems.pl dem$b.tif
image2qtree.pl drg$a.tif 
image2qtree.pl drg$b.tif
