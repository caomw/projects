#!/bin/bash


export RIGHT=0; n=left; rm -rfv albedo_$n;
time reconstruct.sh tmp.txt $n

export RIGHT=1; n=right; rm -rfv albedo_$n;
time reconstruct.sh tmp.txt $n

