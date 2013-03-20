f=$1
g=$(echo $f | perl -pi -e "s#\.r\d+\.tif##g")
dg_mosaic.py $(pwd)/$f --reduce-percent=50 --output-prefix=$g"_sub"

