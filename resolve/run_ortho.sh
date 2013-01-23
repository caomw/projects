#!/bin/bash

while [ 1 ]; do

    out=$(qstat -u $(whoami) |grep $(whoami))
    echo out is $out

    if [ "$out" != "" ]; then
        sleep 60
    else
        break
    fi

done

for ((i = 1; i <=8 ; i++)); do
    qsub driver$i$i.sh
done

