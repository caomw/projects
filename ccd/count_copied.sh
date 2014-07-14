#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 tdi; exit; fi

tdi=$1

echo tdi=$tdi
list=wv01_list.txt
if [ ! -f "$list" ]; then echo Missing $list; exit 1; fi

echo Total:
grep " $tdi " $list | wc

d=0
n=0
for f in $(grep " $tdi " $list | perl -pi -e "s#^.*?\/##g" | print_col.pl 1); do
    g=$(ls ~/projects/data/stereo_antarctic/$f/* |grep .ntf 2>/dev/null);
    if [ "$g" = "" ]; then
        echo "not copied $f"
        ((n++))
        continue;
    fi;
    echo "copied $f"
    ((d++))
done

((t=d+n))
echo "copied: $d, not copied $n, total $t"