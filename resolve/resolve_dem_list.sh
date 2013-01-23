#!/bin/sh

# tell Ara about space after comma

#RUN STEREO
dataDirname="85s_10w"
resDirname="results_85s_10w"

old_IFS=$IFS
IFS=$'\n'
lines=($(cat 85s_10w.csv))
IFS=$old_IFS;

for i in {1..8}
do
    #echo ${lines[1]}
    lroc_1=$(echo ${lines[i]}|cut -d',' -f1)
    lroc_2=$(echo ${lines[i]}|cut -d',' -f2)
    l_img=$lroc_1
    r_img=$lroc_2

    for j in {1..4}
    do
       if [ $j == 1 ]
       then
           l_img=$lroc_1"LE.map.cub"
           r_img=$lroc_2"LE.map.cub"
           resPrefix="$lroc_1""LE_""$lroc_2""LE"
       fi

       if [ $j == 2 ]  
       then
           l_img=$lroc_1"LE.map.cub"
           r_img=$lroc_2"RE.map.cub"
           resPrefix="$lroc_1""LE_""$lroc_2""RE"

       fi

       if [ $j == 3 ]
       then
           l_img=$lroc_1"RE.map.cub"
           r_img=$lroc_2"LE.map.cub"
           resPrefix="$lroc_1""RE_""$lroc_2""LE"
       fi

       if [ $j == 4 ]
       then
           l_img=$lroc_1"RE.map.cub"
           r_img=$lroc_2"RE.map.cub"
           resPrefix="$lroc_1""RE_""$lroc_2""RE"
       fi
          
       l_img="$dataDirname""/""$l_img"
       r_img="$dataDirname""/""$r_img"

       echo $l_img ", " $r_img 

       if [ 1 -eq 1 ] || [ -f "$l_img" ]    
       then
	   if [ 1 -eq 1 ] || [ -f "$r_img" ]
	   then
           
               pairResDirname="$resDirname""_""$resPrefix"
               shadeFile="$pairResDirname""/""$resPrefix""_shade.tif"
               colorShadeFile="$pairResDirname""/"$resPrefix"_clrshade.tif"
               demFile="$pairResDirname""/""$resPrefix""-DEM.tif"
               
               echo $l_img
               echo $r_img
               echo $demFile
               echo $shadeFile
               echo $resPrefix
               echo $resPrefix
               mkdir $pairResDirname
               
               echo stereo --threads 16 $l_img $r_img "$pairResDirname""/""$resPrefix"
               #stereo --threads 16 $l_img $r_img "$pairResDirname""/""$resPrefix"
               #point2dem -r moon $pairResDirnameDir"/"$resPrefix"-PC.tif"
               #hillshade -o $shadeFile -a 315 -s 0 $demFile
               #colormap  --lut-file LMMP_color_medium.lut -o $colorShadeFile -s $shadeFile --moon --legend $demFile
	       #cp $colorShadeFile "colorShade/"$resPrefix"_clrshade.tif"
            else
               echo "missing file: "$r_img
            fi
       else
          echo "missing file: "$l_img
       fi
      
    done

    #exit
    
 done


#image2qtree -m kml colorShade/*.tif
