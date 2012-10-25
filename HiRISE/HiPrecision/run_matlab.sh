#!/bin/bash


base=$HOME/projects/HiRISE/HiPrecision
cd $base

#echo "path(path, '$base');" > $base/tmp_run.m
for d in $(find . |grep tab | perl -pi -e "s#^(.*\/).*?\n#\$1\n#g" | ~/bin/unique.pl | tac); do
    cd $base/$d
    #echo $(echo $(ls *tab) | perl -pi -e "s#[ ]# #g" | perl -pi -e "s#^(.*?)[ ]+(.*?)[ ]+(.*?)(\s.*?\$|\$)# cd $(pwd);\n id='x';\n f1='\$2';\n f2='\$3';\n f3='\$1';#g") 'testrun_orig_fixed(id, f1, f2, f3)' >> $base/tmp_run.m
    echo pwd >> $base/tmp_run.sh
    echo $(echo $(ls *tab) | perl -pi -e "s#[ ]# #g" | perl -pi -e "s#^(.*?)[ ]+(.*?)[ ]+(.*?)(\s.*?\$|\$)# cd $(pwd);\n id='x';\n f1='\$2';\n f2='\$3';\n f3='\$1';#g")  >> $base/tmp_run.sh;
    echo "$base/resolveJitter" ' ./ $id 20 $f1 -1 $f2 -1 $f3 -1' >> $base/tmp_run.sh;
    echo 'max_err.pl x_jitter_cpp.txt ./x_jitter_orig_fixed.txt; max_err.pl x_smear_cpp.txt x_smear.txt' >> $base/tmp_run.sh

    echo "echo ''" >> $base/tmp_run.sh
    echo ""        >> $base/tmp_run.sh 

 done

chmod a+x $base/tmp_run.sh

