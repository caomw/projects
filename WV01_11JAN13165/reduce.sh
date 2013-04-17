#!/bin/bash

module load python/2.7.3

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi
for p in 25 12 6; do
    dg_mosaic.py W*300.tif --reduce-percent=$p
done
#dg_mosaic.py W*E00.tif --reduce-percent=25
