rm -rfv nonmap11; export LOCAL=1 
. isis_setup.sh
stereo M0100115.cub E0201461.cub nonmap11/nonmap -s stereo.default --threads 1 --corr-seed-mode 2 --disparity-estimation-dem ref-DEM.tif --disparity-estimation-dem-error 5 --alignment-method homography --stereo-file stereo.default


