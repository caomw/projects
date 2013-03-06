#!/bin/sh
. isis_setup.sh
for l in 5 4 3 2 1 0; do
  time_run.sh stereo_corr --threads 1 --corr-seed-mode 0 --corr-search -290 -490 10 -190 --corr-max-levels $l M0100115.map.cub E0201461.map.cub map/map -s stereo.map
done



