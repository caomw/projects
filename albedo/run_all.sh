#!/bin/bash
sub=16
f=1
while [ 1 ]; do 
  ((f=2*f))
  echo $f
  nohup nice -19 ./run.sh $f > output$f"_sub$sub".txt 2>&1
  if [ $f -gt 4000 ]; then exit; fi
done  

