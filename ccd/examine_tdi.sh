#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 camera tdi; exit; fi

# Look at the jpeg previews for the stereo pairs with given tdi,
# and save to disk the list of promising pairs to do a run with.
# The value of camera is WV01 or WV02

camera=$1
shift
tdi=$1
execdir=$(dirname $0)
filein=$2
if [ "$filein" != "" ]; then
    files=$(cat $filein)
else
    files=$(ls -d $camera*)
fi

index=index.txt

file=$(pwd)/good_"$camera"_"tdi$tdi".txt
count=0
echo Will write to $file
rm -fv $file
dir=$(pwd)
for f in $files; do
    cd $dir
    if [ ! -d "$f" ] ; then echo missing "$f"; continue; fi
    u=$(ls tmp/$f/* 2>/dev/null | perl -pi -e "s#\s##g") 
    if [ "$u" != "" ]; then echo did $f before, skipping; continue; fi
    g=$(grep TDILEVEL\>$tdi $f/*xml 2>/dev/null | perl -pi -e "s#\n##g")
    if [ "$g" = "" ]; then continue; fi
    g=$(echo $g | perl -pi -e "s#^(.*?\<\/TDILEVEL\>).*?\$#\$1#gs")
    #echo "----$g----"
    ((count++))
    echo "Count is $count"
    cd $f
    a=$(cat $index 2> /dev/null)
    if [ "$a" != "" ]; then
        # Creating the index is slow, use existing if available
        files=$(cat $index | perl -pi -e "s#BROWSE#BROWSE.jpg#g")
        echo "cached $f"
    else
        echo "uncached $f"
        files=$($execdir/print_files.pl jpg | perl -pi -e "s#BROWSE#BROWSE.jpg#g")
    fi
    eog $files

    echo "Enter a (accept) or s (skip)"
    read v
    if [ "$v" = "a" ]; then
        echo $f is good
        echo $f >> $file
    else
        echo $f is bad
    fi
done
