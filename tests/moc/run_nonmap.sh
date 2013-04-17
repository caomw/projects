#!/bin/bash

. isis_setup.sh

dir=nonmap
rm -rfv $dir
time_run.sh stereo M0100115.cub E0201461.cub $dir/$dir --stereo-file stereo.default
point2dem -r mars $dir/$dir-PC.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-PC.tif $dir/$dir-PC.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-L.tif  $dir/$dir-L.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-R.tif  $dir/$dir-R.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-lMask.tif $dir/$dir-lMask.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-rMask.tif $dir/$dir-rMask.tif
