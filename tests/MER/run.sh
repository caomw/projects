rm -rfv nav01
stereo 1n270487304eff90cip1952l0m1.tif 1n270487304eff90cip1952r0m1.tif 1n270487304eff90cip1952l0m1.cahvor 1n270487304eff90cip1952r0m1.cahvor nav01/nav01 --stereo-file ./stereo.default

# rm -rfv mi01
# stereo 2m147677487eff8800p2976m2f1.tif 2m147677547eff8800p2976m2f1.tif 2m147677487eff8800p2976m2f1.cahvor 2m147677547eff8800p2976m2f1.cahvor mi01/mi01 --stereo-file ./stereo.default

for dir in nav01; do
    ~/bin/cmp_images.sh x "$dir"_gold/$dir-PC.tif $dir/$dir-PC.tif
    ~/bin/cmp_images.sh x "$dir"_gold/$dir-L.tif $dir/$dir-L.tif
    ~/bin/cmp_images.sh x "$dir"_gold/$dir-R.tif $dir/$dir-R.tif
    ~/bin/cmp_images.sh x "$dir"_gold/$dir-lMask.tif $dir/$dir-lMask.tif
    ~/bin/cmp_images.sh x "$dir"_gold/$dir-rMask.tif $dir/$dir-rMask.tif
done
