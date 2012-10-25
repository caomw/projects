#!/bin/bash

dir=albedo_exp
mkdir -p $dir/exposure

for f in DIM_input_2560mpp/*tif; do

    g=$(echo $f | perl -pi -e "s#^.*?(AS\w+-M-\d+).*?\$#\$1#g")
    h=$(ls apollo_metric/cubes/a1*/sub4_cubes/$g*);
    e=$(head -n 300 $h |grep -i exp | perl -pi -e "s#ExposureDuration\s*=\s*(.*?)\s*\<milliseconds\>.*?\$#\$1#g")
    echo $f $g $h $e
    echo $e > $dir/exposure/$g"_exposure.txt"
done

