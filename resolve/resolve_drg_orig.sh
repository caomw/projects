#!bin/sh

#PREPROCESSING
mkdir colorShade
mapFile="scyl_40m.map"

for inFile in `echo *.IMG` 
do
  echo "infile = $inFile"

  cubFile=${inFile/IMG/cub}  
  echo "cubFile = $cubFile"

  cubFile_rc=${cubFile/.cub/_rc.cub}  
  echo "cubFile_rc = $cubFile_rc"

  cubFile_sub8=${cubFile/.cub/_rc_sub8.cub}
  echo "cubFile_sub8 = $cubFile_sub8"

  tif_sub8=${cubFile_sub8/.cub/} 

  #cubFile_sub8_map=${cubFile/rc_sub8.cub/rc_sub8_map.cub}
  #echo "cubFileMap_sub8 = $cubFile_sub8_map"
  
  #geoTifFile=${cubFile_sub8/.cub/_geo.tif}

  #lronac2isis FROM = $inFile TO = $cubFile
  
  #add meta data info
  #spiceinit FROM=$cubFile
  
  #radiometric calibration
  #lronaccal FROM=$cubFile TO=$cubFile_rc

  #write the metadata info 
  #campt FROM=$cubFile TO=$txtFile
  
  #downsample the cub files
  #reduce FROM = $cubFile_rc TO = $cubFile_sub8 sscale=8.0 lscale=8.0
  
  #isis2std FROM = $cubFile_sub8 TO = $tif_sub8 FORMAT = TIFF
  #save to geotiffformat
  #cam2map FROM = $cubFile_sub8 MAP = $mapFile TO = $cubFile_sub8_map
  #isis2std FROM = $cubFile_sub8_map TO = $tif_sub8 FORMAT = TIFF
  isis2std FROM = $cubFile_sub8 TO = $tif_sub8 FORMAT = TIFF
  #/byss/packages/gdal-1.7.3/bin/gdal_translate -scale -6000 40000 -ot Byte -co "COMPRESS=LZW" -of GTiff $cubFile_sub8_map $geoTifFile     
done


