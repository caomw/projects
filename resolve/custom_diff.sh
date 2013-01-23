#!/bin/bash


cat $1 $2 | grep d_point | sort -n > data1.txt
cat $3 | grep d_point | sort -n > data2.txt

diff data1.txt data2.txt | head -n 10




