#!/bin/bash

PBS_NODEFILE=localMachines.txt
currDir=$(pwd)
cat todo.txt | perl -pi -e "s#\s+#\n#g" | parallel -P 1 -u --sshloginfile $PBS_NODEFILE "cd $currDir; ./runOne.sh {}" > output_all.txt
