#!/bin/bash

#if [ "$#" -lt 3 ]; then 
    #echo "Usage: $0 tagName remainder quotient"
#    exit
#fi
#tagName=$1
#rem=$2
#quotient=$3

echo Tag is $tagName, running on machine $(uname -n)

list=$(pwd)/list.txt

cubeDir=/nobackupnfs1/oalexan1/projects/albedo/cubes
mkdir -p $cubeDir
cd $cubeDir

for file in $(cat $list | grep AS); do 
#for file in ../DIM_input_sub4/$tagName*tif; do 

    # Wait if too many cubes exist
    while [ 1 ]; do 
        num=$(ls *.cub | wc | awk '{print $2}')
        echo Number of cubes is $num
        if [ $num -gt 3000 ]; then sleep 2; fi
        break;
    done

    num=$(echo $file | perl -pi -e "s#^.*?AS(\d+).*?\$#\$1#g") # from dir/AS17-M-0305... get the value '16'
    prefix=$(echo $file | perl -pi -e "s#^.*\/##g" | perl -pi -e "s#^.*?(AS\d+-M-\d+).*?\$#\$1#g") # get AS17-M-0305
    key=$(echo $file | perl -pi -e "s#^.*?-M-(\d+).*?\$#\$1#g") # get 0305
    cub=$prefix.cub
    echo cub is $cub
    
    #drgImg="";
    #for f in $(ls ../DIM_input_10mpp/$prefix*.tif 2>/dev/null); do drgImg=$f; done

    # Skip the current cube if the drg which we will obtain from it exists
    #if [ 0 ] && [ -e "$drgImg" ]; then
    #    echo File $drgImg exists, will not download the cube $cub
    #    continue
    #fi

    ## Do only the cubes whose remainder of key modulo 4 is rem
    #currRem=$(expr $key % $quotient)
    #if [ $currRem -ne $rem ]; then
    #    echo Will skip $cub as its remainder $currRem is not $rem
    #    continue
    #fi
        
    cubPath="/u/zmoratto/source_data/Apollo"$num"_Metric"
    
    # Skip existing cubes
    if [ -e "$cub" ]; then echo "Cube $cub exists, will not download again"; continue; fi; 

    echo bbftp -u $(whoami) -e "setnbstream 2; cd $cubPath; get $cub" -E 'bbftpd -s -m 2' lou1
    time bbftp -u $(whoami) -e "setnbstream 2; cd $cubPath; get $cub" -E 'bbftpd -s -m 2' lou1
    if [ -e "$cub" ]; then touch $cub; fi; # to create a timestamp
    echo "1----------- The file is $(ls -al $cub)"
    echo "Date is $(date)"

done