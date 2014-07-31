#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 prefix; exit; fi

prefix=$1
maxNum=90 # How many sumultaneous jobs to run
for g in $(ls -d $prefix*[0-9] | grep -v .o); do
    
    q=$(ls $g.o* 2>/dev/null);
    if [ "$q" != "" ]; then
        echo $g was done
        continue
    fi

    q=$(qstat -u $(whoami) | grep $g);
    if [ "$q" != "" ]; then
        echo $g is running
        continue
    fi

    while [ 1 ]; do
        
        numRun=$(qstat -u $(whoami) | grep $(whoami) | wc | awk '{print $1}' | perl -pi -e "s#\s##g")
        echo numRun=$numRun maxNum=$maxNum
        if [ "$numRun" -ge "$maxNum" ]; then
            echo will take a break
            sleep 10
            continue
        fi
        echo Will start $g
        qsub -N $g -l select=1:ncpus=8 -l walltime=4:00:00 -W group_list=s1219 -j oe -m n -- $(pwd)/driver.sh $(pwd)/$g
        sleep 10
        break
        
    done
    
done


