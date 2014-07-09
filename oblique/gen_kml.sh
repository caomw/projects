#!/bin/bash

#t=v9
if [ "$#" -lt 2 ]; then echo Usage: $0 name.kml dir; exit; fi

kml=$1
dir=$2

kml=$kml.kml

base=https://byss.arc.nasa.gov/$(whoami)
root=/byss/docroot/$(whoami)
address=$base/$kml
list=list.html
tmpList=tmpFile.html
# grep -v 0777 | grep -v 0760
links=$(ls $dir*/run-DEM_25pct.tif | perl -pi -e "s#/#_#g" | perl -pi -e "s#\.tif##g" | perl -pi -e "s#^(.*?)\s*\$#$base\/\$1.kml #g")
~/bin/create_combined_kml.pl $kml $links

echo "Number of links: " $(grep -i networklink $kml | wc)

link=$base/$kml
address="<p> <a href=\"$link\">$link</a><br>";
rsync -avz $kml $(whoami)@byss:$root > /dev/null 2>&1
list=list.html
rsync -avz  $(whoami)@byss:$root/$list . > /dev/null 2>&1
tac $list > tmpFile.txt; echo $address >> tmpFile.txt; tac tmpFile.txt > $list
rsync -avz $list $(whoami)@byss:$root > /dev/null 2>&1

echo $link

# cd $root
# tac $list > $tmpList
# echo "<p> <a href=\"$address\">$address</a><br>" >> $tmpList
# tac $tmpList > $list

