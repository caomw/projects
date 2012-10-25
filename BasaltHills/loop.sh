#!/bin/bash

wid=10000

for mpp in 1000 500 250 100 50 25 10; do
    ./run_pcd.sh $mpp $wid | tee output"$mpp"_"$wid".txt
done