#!/bin/bash

./copy.sh

l=$1
n=2
#d=test$1"_"levelj12$l"_"m$n
d=ctx_mosaic_1
machines="$H6 $H9 $H7 $H4"

i=0
for f in $machines $machines $machines $machines; do
    cmd="ssh $f $HOME/plate2kml_example/wrapper.sh $d $l $n $i"
    echo $cmd
    $cmd 2>/dev/null
    ((i++))
    if [ $i -ge $n ]; then break; fi
done

 
