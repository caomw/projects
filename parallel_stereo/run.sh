#!/bin/bash

# Must test when there are no machines!!!
# Must fix how we do the sym links!

mpi="--processes 2 --threads-multi 8 --job-size-w 512 --job-size-h 1024 --correlation-timeout 600 --entry-point 0 --stop-point 6 --nodes-list machines.txt" # --dry-run"

d=../data

# small with crop
#rm -rfv run; parallel_stereo $d/1n270487304eff90cip1952l0m1.tif $d/1n270487304eff90cip1952r0m1.tif $d/1n270487304eff90cip1952l0m1.cahvor $d/1n270487304eff90cip1952r0m1.cahvor run/run -s stereo.default --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --left-image-crop-win 10 15 605 450 $mpi; point2dem  -r moon --nodata-value -32767 run/run-PC.tif; ~/bin/cmp_images.sh x run/run-DEM.tif run2/run-DEM.tif

# # small
# rm -rfv run; parallel_stereo $d/1n270487304eff90cip1952l0m1.tif $d/1n270487304eff90cip1952r0m1.tif $d/1n270487304eff90cip1952l0m1.cahvor $d/1n270487304eff90cip1952r0m1.cahvor run/run -s stereo.default --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 $mpi; point2dem  -r moon --nodata-value -32767 run/run-PC.tif; ~/bin/cmp_images.sh x run/run-DEM.tif run2/run-DEM.tif

# isis
rm -rfv run_isis; parallel_stereo $d/M0100115.map.cub $d/E0201461.map.cub run_isis/run -s stereo.default --corr-search -300 -300 -200 -200 --left-image-crop-win -10 1024 672 4864 --alignment-method none --corr-seed-mode 0 --subpixel-mode 0 $mpi; point2dem  -r mars --nodata-value -32767 run_isis/run-PC.tif; ~/bin/cmp_images.sh x run_isis/run-DEM.tif run_isis_ref/run-DEM.tif

#  --left-image-crop-win 0 1024 672 4864

# bug!!!
#rm -rfv run_isis; parallel_stereo $d/M0100115.cub $d/E0201461.cub run_isis/run  --alignment-method homography --corr-seed-mode 1 --subpixel-mode 1 --stereo-file stereo.default $mpi; point2dem  -r mars --nodata-value -32767 run_isis/run-PC.tif; ~/bin/cmp_images.sh x run_isis/run-DEM.tif run_isis_ref/run-DEM.tif

# Support
