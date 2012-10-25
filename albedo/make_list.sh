#!/bin/bash

ls DIM_input_sub4/AS16-M-*tif | perl -pi -e "s#^.*?\/(.*?).ortho.*?tif\s*#\$1.cub #g" 

# cd /u/zmoratto/source_data/Apollo16_Metric      
# /usr/local/bin/dmfdu .
# scp oalexan1@pfe1:~/projects/albedo/list.txt ~/list.txt
# nohup nice -20 dmget $(cat ~/list.txt) > ~/output.txt 2>&1& 
# nohup nice -20 scp -rqp $(cat ~/list.txt) oalexan1@pfe1:~/projects/albedo/cubeDir > ~/output2.txt 2>&1&
# hp rsync -avz $(cat ~/list.txt) oalexan1@pfe1:~/projects/albedo/cubeDir > ~/output2.txt 2>&1&

