#!/bin/bash

machines="$H6 $H9 $H7 $H4"

for f in $machines; do 
  rsync -avz $HOME/{.ba*,.zshrc,.boto}  $f:$HOME                                    2>/dev/null
  rsync -avz $HOME/bin/gsutil-mp $f:$HOME/bin                                       2>/dev/null
  rsync -avz $HOME/plate2kml_example/*sh $f:$HOME/plate2kml_example                 2>/dev/null
  rsync -avz $HOME/projects/visionworkbench $f:$HOME/projects                       2>/dev/null
  ssh $f "mkdir /scratch/oleg; ln -s /scratch/oleg $HOME/plate2kml_example/scratch" 2>/dev/null
  ssh $f "rm -rfv visionworkbench;  ln -s projects/visionworkbench ."               2>/dev/null
  #rm -fv *tgz; rm -fv *.sh; rm -fv test*; rm -fv *txt; "
  #ssh $f "rm -rfv visionworkbench; rm -fv *tgz; rm -fv *.sh; rm -fv test*; rm -fv *txt; "
  #ssh $f "rm -fv *html; ln -s projects/visionworkbench ."
done

