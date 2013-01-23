#!/bin/zsh

if [ "$#" -lt 4 ]; then echo Usage: $0 dem doOrtho left right;  exit; fi

# This scrit does either the DEM computation or the orthoprojection.
# The former needs to be done on one supercomptuer node, the latter
# needs a lot of nodes.

mpp=$1
doOrtho=$2

a=$3
b=$4
inDir=85s_10w

a=${a/$inDir\//}; a=${a/.cub/}
b=${b/$inDir\//}; b=${b/.cub/}
#a=M139939938LE
#b=M139946735RE

. isis_setup.sh
echo machine is $(uname -n)

outDir="results_"$mpp"mpp"_"$a"_"$b"

mkdir -p $outDir
res=$outDir/"res"

((scale=mpp/4))
if [ $scale -lt 1 ]; then scale=1; fi
echo scale is $scale

. isis_setup.sh

mapFile="sp.map"
if [ ! -e "$mapFile" ]; then
    echo "ERROR: File $mapFile does not exist."
    exit
fi

md=30323.3504241 # meters per degree on moon
((spacing=mpp/md))
echo spacing is $spacing

count=0
for f in $a $b; do

  ((count++))
    
  cubFile=$inDir/$f.cal.cub
  echo "cubFile = $cubFile"

  cubFile_sc=$outDir/$f"_rc_sc".cub
  ortho_drg=${cubFile_sc/_rc_sc.cub/_drg.tif}
  cubFile_map=${cubFile_sc/.cub/_map.cub}

  if [ $doOrtho -eq  0 ]; then

      if [ $scale -ne 1 ]; then 
         #downsample the cub file
          time_run.sh reduce FROM = $cubFile TO = $cubFile_sc sscale=$scale lscale=$scale
      else
          cubFile_sc=$cubFile
      fi
      
      # mapproject the cub file
      #time_run.sh cam2map FROM = $cubFile_sc MAP = $mapFile TO = $cubFile_map pixres=mpp resolution=$mpp
  fi
  
  if [ $count -eq 1 ]; then left_sc=$cubFile_sc; fi
  if [ $count -eq 2 ]; then right_sc=$cubFile_sc; fi

  if [ $count -eq 1 ]; then left_map=$cubFile_map; fi
  if [ $count -eq 2 ]; then right_map=$cubFile_map; fi

  if [ $count -eq 1 ]; then left_drg=$ortho_drg; fi
  if [ $count -eq 2 ]; then right_drg=$ortho_drg; fi
  
done

if [ $doOrtho -eq  0 ]; then 
    time_run.sh stereo -s stereo_win.default --threads 16 $left_sc $right_sc $res
    #time_run.sh stereo -s stereo_win.default --threads 16 $left_map $right_map $res
    time_run.sh point2dem --errorimage --dem-spacing $spacing --nodata-value -32767 --threads 1 -r moon $res-PC.tif
    time_run.sh show_dems.pl $res-DEM.tif
    time_run.sh remote_copy.pl $res-DEM.tif $L2
fi

if [ $doOrtho -ne  0 ]; then 
    time_run.sh tile_orthoproject.pl --threads 16 $res-DEM.tif $left_sc  --mpp $mpp $left_drg
    #time_run.sh tile_orthoproject.pl --threads 16 $res-DEM.tif $right_sc --mpp $mpp $right_drg
    
    time_run.sh image2qtree.pl $left_drg
    time_run.sh remote_copy.pl $left_drg $L2
    #time_run.sh image2qtree.pl $right_drg
    #time_run.sh remote_copy.pl $right_drg $L2
fi

#geoTifFile=${cubFile_sub8/.cub/_geo.tif}
#write the metadata info 
#campt FROM=$cubFile TO=$txtFile

#save to geotiffformat
#isis2std FROM = $cubFile_sub8_map TO = $tif_sub8 FORMAT = TIFF
#/byss/packages/gdal-1.7.3/bin/gdal_translate -scale -6000 40000 -ot Byte -co "COMPRESS=LZW" -of GTiff $cubFile_sub8_map $geoTifFile     


