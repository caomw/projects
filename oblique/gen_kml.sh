#!/bin/bash

t=v9
dir=run5_sub4_25deg
#dir=run2_sub16_25deg
kml=$dir"_"$t.kml

base=https://byss.arc.nasa.gov/oleg
root=/byss/docroot/oleg
address=$base/$kml
list=list.html
tmpList=tmpFile.html

links=$(ls $dir"_"*/img-DEM.tif | grep -v 0777 | grep -v 0760 | perl -pi -e "s#.tif##g" | perl -pi -e "s#/#_#g" | perl -pi -e "s#^(.*?)\s*\$#$base/\$1\/\$1.kml #g")
~/bin/create_combined_kml.pl $root/$kml $links

cd $root
echo "Number of links: " $(grep -i networklink $kml | wc)

tac $list > $tmpList
echo "<p> <a href=\"$address\">$address</a><br>" >> $tmpList
tac $tmpList > $list

