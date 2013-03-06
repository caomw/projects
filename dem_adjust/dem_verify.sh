rm -fv  egm96-adj.tif  navd88-adj.tif mars-adj.tif

dem_geoid zone10-CA_SanLuisResevoir-9m_crop.tif -o egm96 --double
~/bin/cmp_images.sh x egm96-adj.tif gold/egm96.tif

dem_geoid zone10-CA_SanLuisResevoir-9m_crop_nad83.tif -o navd88 --double
~/bin/cmp_images.sh x navd88-adj.tif gold/navd88.tif

dem_geoid mars.tif -o mars --double
~/bin/cmp_images.sh x mars-adj.tif gold/mars-adj.tif
