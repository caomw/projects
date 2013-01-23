#!/bin/zsh

links=""

t=v7
prefix1=run4_sub4_25deg
prefix2=run3_sub4_25deg
kml=$t.kml
base=https://byss.arc.nasa.gov/oleg
root=/byss/docroot/oleg
address=$base/$kml
list=list.html
tmpList=tmpFile.html

for f in $(cat list2.txt); do

    ((g=$f+1))
    if [ $g -lt 1000 ]; then
        dir1="$prefix1"_"$f"_0"$g"
        dir2="$prefix2"_"$f"_0"$g"
    else
        dir1="$prefix1"_"$f"_"$g"
        dir2="$prefix2"_"$f"_"$g"
    fi

    dir1="$dir1"_"img-DEM/$dir1"_"img-DEM.kml"
    dir2="$dir2"_"img-DEM/$dir2"_"img-DEM.kml"

    links="$links $base/$dir1 $base/$dir2"

done

~/bin/create_combined_kml.pl $root/$kml $links

cd $root
echo "Number of links: " $(grep -i networklink $kml | wc)

ls $list

tac $list > $tmpList
echo "<p> <a href=\"$address\">$address</a><br>" >> $tmpList
tac $tmpList > $list

