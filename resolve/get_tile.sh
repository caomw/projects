#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 i mpp; exit; fi

RUN=run4

source ~/.bashenv # need this if running on the supercomp

i=$1
mpp=$2
((pct=100/mpp))

dir=$(ls -dl res*1mpp*$RUN | head -n $i | tail -n 1 | print_col.pl 0 | perl -pi -e "s#\s##g")
leftCub=$(echo $dir | perl -pi -e "s#^.*?(M.*?)_.*?\$#\$1#g")
leftCub=85s_10w/$leftCub.cal.cub

. isis_setup.sh
echo machine is $(uname -n)

echo $dir/res-DEM.tif


if [ "$i" -eq 8 ]; then win="2069 15169 3000 3000"; fi
if [ "$i" -eq 7 ]; then win="1297 11782 3000 3000"; fi
if [ "$i" -eq 6 ]; then win="903 14726 3000 3000";  fi
if [ "$i" -eq 5 ]; then win="1314 18825 3000 3000"; fi
if [ "$i" -eq 4 ]; then win="921 18629 3000 3000";  fi
if [ "$i" -eq 3 ]; then win="512 13284 3000 3000";  fi
if [ "$i" -eq 2 ]; then win="200 13950 3000 3000";  fi
if [ "$i" -eq 1 ]; then win="100 10200 2600 3000";  fi

DEM_prefix=$dir/res-DEM
DRG_prefix=$dir/res-DRG
tileDEM=$DEM_prefix"_tile""_"$mpp"mpp".tif
tileDRG=$dir/res-DRG_tile"_"$mpp"mpp".tif
tileDEMError=$DEM_prefix"Error_tile""_"$mpp"mpp".tif
echo $DEM_prefix.tif

echo $tileDEM
cmd="gdal_translate -srcwin $win -outsize $pct% $pct% $DEM_prefix.tif $tileDEM"
echo $cmd
$cmd
remote_copy.pl $tileDEM $L2
show_dems.pl $tileDEM
echo $tileDEM

echo $tileDRG
cmd="gdal_translate -srcwin $win -outsize $pct% $pct% $DRG_prefix.tif $tileDRG"
echo $cmd
$cmd
remote_copy.pl $tileDRG $L2
tileDRG_int=${tileDRG/.tif/_int.tif}
float2int2.pl $tileDRG $tileDRG_int
image2qtree.pl $tileDRG_int 

cmd="gdal_translate -srcwin $win -outsize $pct% $pct% $DEM_prefix"Error".tif $tileDEMError"
echo $cmd
$cmd
plot_err.sh $tileDEMError 1
remote_copy.pl $DEM_prefix"Error_tile"*tif $L2

