#!/bin/bash


for mpp in 25 10 5; do
    for i in 500 4000 8000; do
        #./run1.sh $i $i 1
        ./run_pcd.sh $i $mpp
    done
done

    