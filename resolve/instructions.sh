#!/bin/bash

1. Scale a DRG to visualize it:

gdal_translate -scale 0 0.253 0 255 -ot byte results_1mpp_M139906018LE_M139912793RE_run4/LRONAC_DRG_000deg42minW_84deg52minS.tif output_byte.tif

This produces images which are rather dark (because the mean image value is much less than the max). The following produces lighter images:

gdal_translate -scale 0 0.10 0 255 -ot byte results_1mpp_M139906018LE_M139912793RE_run4/LRONAC_DRG_000deg42minW_84deg52minS.tif output_byte.tif

2. Mosaics:

a. To build vrt:

gdalbuildvrt DRG_mosaic.tif results_1mpp*/LRO*DRG_*tif

gdalbuildvrt DEM_mosaic.tif results_1mpp*/LRO*DEM_*tif

b. To visualize a scaled version of the DRG at sub10:

gdal_translate -scale 0 0.10 0 255 -ot byte -outsize 10% 10% DRG_mosaic.tif DRG_mosaic_byte_sub10.tif

c. To visualize a hillshaded and scaled version of the DEM:

gdal_translate -outsize 10% 10% DEM_mosaic.tif DEM_mosaic_sub10.tif

gdaldem hillshade -az 300 -alt 15 DEM_mosaic_sub10.tif hillshade_mosaic_sub10.tif

6. Visualizing the DEM errors:

for b in 1 2 3; do

  gdal_translate -b $b results_1mpp_M139939938LE_M139946735RE_run4/LRONAC_DEMError_005deg22minW_85deg12minS.tif band$b.tif

  gdaldem color-relief band$b.tif LMMP_color_medium.lut colored_band$b.tif

done
