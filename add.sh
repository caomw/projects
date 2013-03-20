for ext in m h c cc cpp pl py sh; do
 files=$(ls ./*.$ext ./*/*.$ext)
  time_run.sh git add $files
done

