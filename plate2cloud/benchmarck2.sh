#!/bin/bash

function do_run {

    CTX=/big/platefiles/googleearth/ctx_snapshot_v3.plate
    #CTX=/big/platefiles/googleearth/ctx_v3_snapshot_4.plate
    SRC=$HOME/visionworkbench/src/vw/Plate
    RDIR=$(pwd)
    
    l=$1
    tag=$2

    #cd $SRC
    #touch detail/$tag/*; \cp -fv detail/$tag/* detail/; make plate2kml
    #cd $RDIR
    
    DIR=test$l"_"$tag
    for lc in 1 0; do
        rm -rf $DIR
        export WRITE=1;
        export LOCAL=$lc;
        echo "Running level=$l tag=$tag WRITE=$WRITE LOCAL=$LOCAL"
        ans=$(time $SRC/plate2kml $CTX -o $DIR -p mars -l $l -n 1 -i 0 2>&1 1>/dev/null)
        if [ $lc -eq 1 ]; then
            size=$(du -m $DIR | tail -n 1 | perl -pi -e "s#(\d)(\s+)#\$1 MB\$2#g")
            echo Size of $DIR for level $l is $size
        fi
        \rm -rf $DIR
        sleep 2
        echo " "
    done
}

for ((l = 5; l < 15; l++)); do
    #do_run $l before
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

