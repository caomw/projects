#!/bin/sh
. isis_setup.sh
time_run.sh stereo --threads 16 --corr-seed-mode 1 --corr-search -290 -490 10 -190 --corr-max-levels 5 M0100115.map.cub E0201461.map.cub map/res -s stereo.map
