#!/bin/bash

for d in 0.4 0.8 0.2; do
    for c in 2.0 3.0 1.0; do

        echo "$c $d" > exp_factor.txt
        n=$(echo "c$c"_"d$d" | perl -pi -e "s#\.#p#g")
        echo $n
        reconstruct.sh photometry_settings_2560mpp_oleg.txt $n > output.txt
        rsync -avz albedo_$n oalexan1@byss:~/projects/albedo/
        ssh oalexan1@byss "cd ~/projects/albedo/; export PATH=$PATH:~/projects/base_system/bin/; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/packages/lib/:~/protobuf-2.4.1/build/lib; ./make_kml_tiles.pl albedo_$n/albedo"
    done
done

