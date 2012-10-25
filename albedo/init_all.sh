#!/bin/bash

. isis_setup.sh

for f in /byss/moon/apollo_metric/cubes/a15_oblique/sub4_cubes_*deg/*.lev1.cub; do
    echo $f
    $ISISROOT/bin/spiceinit from=$f
done