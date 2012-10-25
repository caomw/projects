#!/bin/bash

for ((i = 0; i <= 20; i++)); do
    perl -pi -e "s#MAX_NUM_ITER              \d+#MAX_NUM_ITER              $i#g" photometry_settings.txt 
    n=$i"_sub64";
    n0=0"_sub64";
    rm -rfv albedo_$n;
    if [ $i -gt 0 ]; then cp -rfv albedo_"$n0" albedo_"$n"; fi
    reconstruct.sh photometry_settings.txt $n > output$n.txt 2>&1
done

