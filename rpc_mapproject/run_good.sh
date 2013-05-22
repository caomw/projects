opt="+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"   

/usr/bin/time rpc_mapproject --tr 10 --t_srs "$opt" krigged_dem_nsidc_ndv0_fill.tif WV01_11JAN131652222-P1BS-10200100104A0300.tif WV01_11JAN131652222-P1BS-10200100104A0300.xml good.tif

