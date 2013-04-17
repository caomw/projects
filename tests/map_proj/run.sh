dir=res
rm -rfv $dir

stereo --corr-seed-mode 1 --corr-max-levels 5 -t dg -s stereo.default --threads 16 --alignment-method none --subpixel-mode 0 --disable-fill-holes left.tif right.tif left.xml right.xml $dir/$dir krigged_dem_nsidc_ndv0_fill.tif

point2dem -r earth --threads 1 $dir/$dir-PC.tif
show_dems.pl $dir/$dir-DEM.tif

~/bin/cmp_images.sh x  $dir/$dir-PC.tif "$dir"_gold/$dir-PC.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-L.tif $dir/$dir-L.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-R.tif $dir/$dir-R.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-lMask.tif $dir/$dir-lMask.tif
~/bin/cmp_images.sh x "$dir"_gold/$dir-rMask.tif $dir/$dir-rMask.tif
