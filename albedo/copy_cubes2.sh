#!/bin/bash

angle=45
list=$(pwd)/list"$angle".txt
cubeDir=/nobackupnfs1/oalexan1/projects/albedo/cubes"$angle"
mkdir -p $cubeDir
cd $cubeDir

rm -fv *lev0*cub *lev1*cub

for file in $(cat $list | grep AS | perl -pi -e "s#\.lev\d*##g"); do

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
    
    cubPath="/u/zmoratto/source_data/Apollo"$num"_Metric"
    
    # Skip existing cubes
    if [ -e "$cub" ]; then
        echo "Cube $cub exists, will not download again";
    else
        echo bbftp -u $(whoami) -e "setnbstream 2; cd $cubPath; get $cub" -E 'bbftpd -s -m 2' lou1
        time bbftp -u $(whoami) -e "setnbstream 2; cd $cubPath; get $cub" -E 'bbftpd -s -m 2' lou1
    fi 

    if [ -e "$cub" ]; then touch $cub; fi; # to create a timestamp
    echo "1----------- The file is $(ls -al $cub)"
    echo "Date is $(date)"

    echo "Will do file: $cub"
    . isis_setup.sh
    
    ~/projects/ApolloMetricProcessing/Python/FilePrep/time_check_modify.py $cub
    spiceinit from=$cub
    ~/projects/ApolloMetricProcessing/Python/FilePrep/reduce_cube.py $cub

    rsync -avz *lev1*cub oalexan1@byss:/data/moon/apollo_metric/cubes/a15_oblique/sub4_cubes_"$angle"deg
done