cd /byss/docroot/albedo/AMCAM_0001/data 

ls *E.tif | xargs -I {} -P 8  /byss/packages/gdal-1.8.1/bin/gdal_translate -outsize 10% 10% {} ~/projects/albedo/error_sub10/{}


