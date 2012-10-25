#!/bin/bash

function do_run {

    CTX=/big/platefiles/googleearth/ctx_snapshot_v3.plate
    SRC=$HOME/visionworkbench/src/vw/Plate
    RDIR=$(pwd)
    
    l=$1
    tag=$2

    cd $SRC
    touch detail/$tag/*; \cp -fv detail/$tag/* detail/; make plate2kml

    cd $RDIR
    DIR=test$l"_"$tag
    rm -rf $DIR
    for w in 0 1; do
        export WRITE=$w;
        export LOCAL=1;
        echo "Running level=$l tag=$tag WRITE=$WRITE"
        ans=$(time $SRC/plate2kml $CTX -o $DIR -p mars -l $l -n 1 -i 0 2>&1)
        echo Size of $DIR is $(du $DIR | tail -n 1)
        sleep 2
        echo " "
    done
}

for ((l = 5; l < 11; l++)); do
    do_run $l before
    do_run $l after
done

exit


exit

S=$(du -h $DIR | tail -n 1)
echo Size is $S

echo time is $(date)
time ../Python-2.7.2/build/bin/python ../bin/gsutil-mp/gsutil -m cp -R $DIR gs://olegtest/
echo time is $(date)


export LOCAL=0; 
DIR=testj$l$LOCAL
time plate2kml $CTX -o $DIR -p mars -l $l -n 1 -i 0

