. isis_setup.sh

rm -fv *lev0*cub *lev1*cub

for f in $(cat ~/projects/albedo/list.txt | perl -pi -e "s#\.lev\d*##g"); do 
   echo "Will do file: $f"
   ~/projects/ApolloMetricProcessing/Python/FilePrep/time_check_modify.py $f 
    spiceinit from=$f
   ~/projects/ApolloMetricProcessing/Python/FilePrep/reduce_cube.py $f 
done


