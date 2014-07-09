#!/bin/bash

source ~/.bashenv
for d in a*; do if [ ! -d "$d" ]; then continue; fi; for f in $(ls $d/*/dx.txt $d/*/dy.txt 2>/dev/null); do echo $f; dir=$(dirname $f); ssh $L1 "mkdir -p projects/ccd/$dir/" 2>/dev/null; rsync -avz $f $L1:projects/ccd/$dir/ 2>/dev/null; done; done

