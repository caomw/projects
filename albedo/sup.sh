#!/bin/sh

for dir in visionworkbench/src/vw/Photometry StereoPipeline/src/asp/Tools projects/albedo; do
    cd ~/$dir;
    pwd;
    files="";
    for f in *.cc *.h photo*.txt *.pl *.sh *.py *.java *.class filter* meta; do
        if [ -e "$f" ]; then files="$files $f"; fi
    done
    #echo List is $files
    sup rsync -avz -T /tmp $files pfe1:$dir;
done
