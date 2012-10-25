#!/bin/bash

cd $HOME/projects/albedo
num=$(ls -d -t backup/*[0-9] | head -n 1 | perl -pi -e "s#^.*\/##g")
((num++))

bkdir=backup/$num;
for d in $HOME/visionworkbench/src/vw/Photometry $HOME/StereoPipeline/src/asp/Tools $HOME/projects/albedo; do
    cd $d;
    echo Will backup $(pwd) to $bkdir
    mkdir -p $bkdir;
    for f in *.cc *.h photo*.txt *.pl *.sh *.py *.java *.class; do
        if [ -e $f ]; then cp $f $bkdir; fi;
    done
done