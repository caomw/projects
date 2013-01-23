#!/bin/bash

183 stereo pairs.

Need to understand the following missing 22 DEM:

# 1 why? The cameras are very bad
qview sub4_cubes_25deg/AS15-M-0760.lev1.cub sub4_cubes_25deg/AS15-M-0761.lev1.cub

#2 right is awful
qview sub4_cubes_25deg/AS15-M-1350.lev1.cub sub4_cubes_25deg/AS15-M-1351.lev1.cub 

#3 left is awful
qview sub4_cubes_25deg/AS15-M-1351.lev1.cub sub4_cubes_25deg/AS15-M-1352.lev1.cub

#4 why, reran it and it looks good
qview sub4_cubes_25deg/AS15-M-1356.lev1.cub sub4_cubes_25deg/AS15-M-1357.lev1.cub

#5 right is awful
qview sub4_cubes_25deg/AS15-M-1361.lev1.cub sub4_cubes_25deg/AS15-M-1362.lev1.cub

#6 left is awful
qview sub4_cubes_25deg/AS15-M-1362.lev1.cub sub4_cubes_25deg/AS15-M-1363.lev1.cub

#7 right is awful
qview sub4_cubes_25deg/AS15-M-1367.lev1.cub sub4_cubes_25deg/AS15-M-1368.lev1.cub

#8 left is awful
qview sub4_cubes_25deg/AS15-M-1368.lev1.cub sub4_cubes_25deg/AS15-M-1369.lev1.cub

#9 why. Rerun!!! on pfe8, looks good at sub16
# Correlation failed at sub4, the search window is huge!!! Need to investigate
# Found a bug in ransac. Fixed!
qview sub4_cubes_25deg/AS15-M-1390.lev1.cub sub4_cubes_25deg/AS15-M-1391.lev1.cub

#10 right is awful
qview sub4_cubes_25deg/AS15-M-1392.lev1.cub sub4_cubes_25deg/AS15-M-1393.lev1.cub

#11 left is awful
qview sub4_cubes_25deg/AS15-M-1393.lev1.cub sub4_cubes_25deg/AS15-M-1394.lev1.cub

# 12 why Rerun!!! on pfe9, looks good at sub16
# way too slow at sub4, the search window is huge!!! need to investigate
# Found a bug in ransac. Fixed!
qview sub4_cubes_25deg/AS15-M-1399.lev1.cub sub4_cubes_25deg/AS15-M-1400.lev1.cub

# 13 right is awful
qview sub4_cubes_25deg/AS15-M-1402.lev1.cub sub4_cubes_25deg/AS15-M-1403.lev1.cub

# 14 left is awful
qview sub4_cubes_25deg/AS15-M-1403.lev1.cub sub4_cubes_25deg/AS15-M-1404.lev1.cub

# 15 right is awful
 qview sub4_cubes_25deg/AS15-M-1415.lev1.cub sub4_cubes_25deg/AS15-M-1416.lev1.cub

# 16 left is awful
 qview sub4_cubes_25deg/AS15-M-1416.lev1.cub sub4_cubes_25deg/AS15-M-1417.lev1.cub

# 17 right is awful
 qview sub4_cubes_25deg/AS15-M-1419.lev1.cub sub4_cubes_25deg/AS15-M-1420.lev1.cub

# 18 both left and right are awful
qview sub4_cubes_25deg/AS15-M-1420.lev1.cub sub4_cubes_25deg/AS15-M-1421.lev1.cub

# 19 left is awful
qview sub4_cubes_25deg/AS15-M-1421.lev1.cub sub4_cubes_25deg/AS15-M-1422.lev1.cub

# 20 why, reran on pfe12, looks good
qview sub4_cubes_25deg/AS15-M-1422.lev1.cub sub4_cubes_25deg/AS15-M-1423.lev1.cub

# 21 right is awful
qview sub4_cubes_25deg/AS15-M-1425.lev1.cub sub4_cubes_25deg/AS15-M-1426.lev1.cub

# 22 left is awful
 qview sub4_cubes_25deg/AS15-M-1426.lev1.cub sub4_cubes_25deg/AS15-M-1427.lev1.cub


# Weird 4:
run2_sub16_25deg_0759_0760_img-DEM # really bad camera info for 0760
run2_sub16_25deg_0776_0777_img-DEM # really bad camera info for 0777
run2_sub16_25deg_0777_0778_img-DEM # really bad camera info for 0777 
1356_1357 # is very bad need to investigate, was OK next time
 
Other: 157 dem

1391
1394
1401
1411
1412
1413
1417
1397
0806
0842
0849
0850
1339
1344
1389
1345
1352
1353
1354
1355
1405
1406
1408
1356
1364
1365
1407
0784
0785
0809
0810
1364
1366
1382








# run2_sub16_25deg_0846_0848_img-DEM
# run2_sub16_25deg_1421_1422_img-DEM


. isis_setup.sh

time_mod=~/projects/ApolloMetricProcessing/Python/FilePrep/time_check_modify.py

#cub1=sub16_cubes_25deg/AS15-M-1413.lev1.cub
cub1=AS15-M-1413.lev1.cub
cub1_out=AS15-M-1413_v4_map.cub
\cp -fv /byss/moon/apollo_metric/cubes/a15_oblique/sub4_cubes_25deg/$cub1 .
spiceinit from=$cub1
$time_mod $cub1
spiceinit from=$cub1
cam2map from=$cub1 to=$cub1_out pixres=mpp resolution=160 
image2qtree.pl $cub1_out

cub2=AS15-M-2254.lev1.cub
cub2_out=AS15-M-2254_v4_map.cub
\cp -fv /byss/moon/apollo_metric/cubes/a15/sub4_cubes/$cub2 .
spiceinit from=$cub2
$time_mod $cub2
spiceinit from=$cub2
cam2map from=$cub2 to=$cub2_out pixres=mpp resolution=160 
image2qtree.pl $cub2_out


Good pair to experiment with:  sub16_cubes_25deg/AS15-M-1413.lev1.cub sub16_cubes_25deg/AS15-M-1414.lev1.cub

Will delete: data/res-25deg-sub16-0817-0838/img-DEM.tif

Problem pairs:

Bug:

rm -rfv data/res-45deg-sub16-1538-1539
. isis_setup.sh
time_run.sh stereo_pprc sub16_cubes_45deg/AS15-M-1538.lev1.cub sub16_cubes_45deg/AS15-M-1539.lev1.cub data/res-45deg-sub16-1538-1539/img --cache-dir data/res-45deg-sub16-1538-1539/cache --stereo-file stereo_parabola.default

