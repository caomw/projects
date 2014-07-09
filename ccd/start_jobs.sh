#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi
maxNum=20

for g in 100 113 115 120 122 124 126 127 129 130 133 134 135 136 137 138 139 140 143 144 147 148 150 155 156 158 159 163 165 169 174 175 176 178 180 182 184 185 186 189; do 
    g=a$g
#for g in $(ls -d a* | grep -v .o); do
    
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
        qsub -N $g -l select=1:ncpus=8 -l walltime=5:00:00 -W group_list=s1219 -j oe -m n -- $(pwd)/driver.sh $(pwd)/$g
        sleep 30
        break
        
    done
    
done


