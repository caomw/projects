#!/bin/bash

maxNum=50
# # Don't do the while loop, not all pairs succeed!
# while [ 1 ]; do

for f in REV35/*cub; do

    j=$(echo $f | perl -pi -e "s#^.*?(AS\d*-M-\d+).*?\$#\$1#g");
    echo $j
    
    #t=$(ls REV*AS*/*PC.tif | grep $j"_");
    #if [ "$t" != "" ]; then echo Skip $j $t; continue; fi;

    t=$(qstat -u $(whoami) | grep $j);
    if [ "$t" != "" ]; then echo Skip $j $t; continue; fi;

    while [ 1 ]; do 
        count=$(qstat -u $(whoami) | grep AS | wc | awk '{print $1}')
        if [ "$count" -ge "$maxNum" ]; then
            echo "Reached count $maxNum, will wait"
            sleep 60
        else
            qsub -N $j -l select=1:ncpus=8 -l walltime=6:00:00 -W \
                group_list=s1219 -j oe -m n -- $(pwd)/run_pair.sh $(pwd) $f;
            sleep 4
            break
        fi
    done
    
done

# sleep 60

# done
