#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 tdi; exit; fi

tdi=$1
execdir=$(dirname $0)

file=$(pwd)/good$tdi.txt
count=0
echo Will write to $file
rm -fv $file
dir=$(pwd)
for f in WV01*; do
    cd $dir
    if [ ! -d "$f" ]; then continue; fi
    g=$(grep TDILEVEL\>$tdi $f/*xml 2>/dev/null | perl -pi -e "s#\n##g")
    if [ "$g" = "" ]; then continue; fi
    g=$(echo $g | perl -pi -e "s#^(.*?\<\/TDILEVEL\>).*?\$#\$1#gs")
    echo "----$g----"
    ((count++))
    echo "---count is $count ---"
    cd $f
    files=$($execdir/print_files.pl | perl -pi -e "s#BROWSE#BROWSE.jpg#g")
    echo " -- $f --"
    eog $files

    echo enter a or s
    read v
    if [ "$v" = "a" ]; then
        echo $f is good
        echo $f >> $file
    else
        echo $f is bad
    fi
done
