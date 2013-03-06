#!/bin/bash

. isis_setup.sh

t="_sub4"
dir=no_align_seed1$t
pref=$dir/res
rm -rfv $dir
time_run.sh stereo M0100115$t.cub E0201461$t.cub $pref -s stereo.nonmap --corr-search -1000 -1000 1000 1000 --subpixel-mode 2 --corr-seed-mode 1 --alignment-method none --threads 16
time_run.sh point2dem -r mars $pref-PC.tif
time_run.sh show_dems.pl $pref-DEM.tif
