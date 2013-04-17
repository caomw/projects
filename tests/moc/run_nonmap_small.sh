#!/bin/bash

. isis_setup.sh

dir=nonmap_small
rm -rfv $dir
time_run.sh stereo M0100115.cub E0201461.cub $dir/res --stereo-file stereo.default --left-image-crop-win 0 1024 672 4864 --subpixel-mode 1
point2dem -r mars $dir/res-PC.tif

~/bin/cmp_images.sh x "$dir"_gold/res-PC.tif $dir/res-PC.tif
~/bin/cmp_images.sh x "$dir"_gold/res-L.tif  $dir/res-L.tif
~/bin/cmp_images.sh x "$dir"_gold/res-R.tif  $dir/res-R.tif
~/bin/cmp_images.sh x "$dir"_gold/res-lMask.tif $dir/res-lMask.tif
~/bin/cmp_images.sh x "$dir"_gold/res-rMask.tif $dir/res-rMask.tif
