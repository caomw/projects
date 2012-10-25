#!/bin/bash

source ~/.bashenv

for t in 1 2; do
    echo '--------'
    echo Attempt $t
    echo '--------'
    #for f in $(uname -n) $B $L1 $L2 $A $C $D; do 
        killall java batch_scale.sh run_all.sh xargs gdal_translate run.sh reconstruct lt-reconstruct cmd.sh run.sh reconstruct.sh time run_job.pl run_job2.pl get_job_id.pl 2>/dev/null
        # ps ux 2>/dev/null | grep $(whoami)| grep -v zsh | grep -v sshd
    #done

    #sleep 2;

done
