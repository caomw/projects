#!/bin/bash

currDir=$(pwd);
ls -alh -rtd */*PC.tif | perl -pi -e "s#\s*\$#\n#g" | grep "Nov  7" | print_col.pl 0 | perl -pi -e "s#\s*\$#\n#g" | parallel -P 8 -u --sshloginfile localMachines.txt "cd $currDir; point2dem --threads 1 -r moon --nodata-value -32767 {} -o {.}-v3"

ls -alh -rtd */*PC-v3-DEM*tif| grep -v run3_sub4_25deg_0850_0851/img-PC-v3-DEM.tif | perl -pi -e "s#\s*\$#\n#g" | grep "Nov  7" | print_col.pl 0 | perl -pi -e "s#\s*\$#\n#g" | parallel -P 8 -u --sshloginfile localMachines.txt "cd $currDir; show_dems.pl {}"
