#!/bin/bash

for ((i=0; i<=400; i++)); do 
    for f in [a-z]*.o*; do
        f=$(echo $f | perl -pi -e "s#\.o\d+##g"); echo $f; rm -fv $f/*/*-{RD,PC,L,R,D,hill,lmask,rmask,Good,align,crop-F}*tif
    done
    sleep 3600;
done
