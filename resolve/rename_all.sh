#!/bin/bash

RUN=run4

for f in results_1mpp*"$RUN"/res-DRG[0-9][0-9].tif results_1mpp*"$RUN"/res-DEM[0-9][0-9].tif results_1mpp*"$RUN"/res-DEMError[0-9][0-9].tif; do
    
    #echo $f
    rename.pl $f
    
done