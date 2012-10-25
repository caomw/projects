#!/bin/bash

machines="$H6 $H9 $H7 $H4"
for f in $machines; do
    scp $f:$HOME/plate2kml_example/scratch/output_run\* .
done
