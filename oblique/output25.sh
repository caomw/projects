nohup: ignoring input
Job is all
./driver25.sh: line 36: 10231 Done                    echo $list
     10232                       | perl -pi -e "s#\s+#\n#g"
     10233 Killed                  | parallel -P 1 -u --sshloginfile $PBS_NODEFILE "cd $currDir; $run" > output$jobName.txt
