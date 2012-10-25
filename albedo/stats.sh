for f in DIM_input_sub32/*tif DEM_input_sub32/*tif; do 
  echo $f 
  gdalinfo -stats $f;
  echo ""
  echo ""
done



