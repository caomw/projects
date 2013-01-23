#!/bin/bash

. isis_setup.sh

if [ "$#" -lt 1 ]; then echo Usage: $0 mpp;  exit; fi

mpp=$1

l=M139939938LE
r=M139946735RE
DEM=results_4mpp_bayes_85s_10w_"$l"_"$r"/"$l"_"$r"-DEM.tif
suff=cal_ortho_"$mpp"mpp.tif
lDRG=85s_10w/"$l"_"$suff"
rDRG=85s_10w/"$r"_"$suff"
echo "DEM = $DEM, left orthoprojected DRG = $lDRG, right orthoprojected DRG = $rDRG"

time orthoproject --threads 16 "$DEM" 85s_10w/"$l".cal.cub --mpp "$mpp" $lDRG

time orthoproject --threads 16 "$DEM" 85s_10w/"$r".cal.cub --mpp "$mpp" $rDRG

 

