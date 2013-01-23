#!/bin/zsh

if [ "$#" -lt 3 ]; then echo Usage: $0 mpp tag subpixel_kernel;  exit; fi

# This scrit does either the DEM computation or the orthoprojection.
# The former needs to be done on one supercomptuer node, the latter
# needs a lot of nodes.

mpp=$1 # resolution used to create the DEM
tag=$2
sk=$3

enlarge=1
reduce=1
if [ $((mpp < 1)) -eq 1 ]; then
    ((enlarge=1.0/mpp))
    echo "Will enlarge by $enlarge"
else
    ((reduce=mpp))
    echo "Will reduce by $reduce"
fi

echo "mpp is $mpp"

. isis_setup.sh
echo machine is $(uname -n)

#2532, 52224
#wid=1000; hgt=1000
wid=500; hgt=500
shiftx1=500
shiftx2=780
shifty1=15000
shifty2=16225

inDir=85s_10w
a=M139939938LE
b=M139946735RE

mapFile="sp.map"
if [ ! -e "$mapFile" ]; then
    echo "ERROR: File $mapFile does not exist."
    exit
fi

t=$tag"_"$mpp"mpp"_"subpix$sk"
t=$(echo $t | perl -pi -e "s#\.#p#g")

dir="res_"$t"_crop"$wid"_"$hgt"_"$shiftx1"_"$shifty1
mkdir -p $dir
res=$dir/res

md=30323.3504241 # meters per degree on moon
((spacing=mpp/md))
#((spacing=spacing/2.0))
spacing=0.000016488900656
echo spacing is $spacing

count=0
for f in $a $b; do

    ((count++))
    
    cubFile=$inDir/$f.cal.cub
    cropped=$dir/$f"_crop".cub
    scaled=$dir/$f"_scaled".cub
    mapped=$dir/$f"_map".cub
    
    if [ $count -eq 1 ]; then
        shiftx=$shiftx1; shifty=$shifty1;
    else
        shiftx=$shiftx2; shifty=$shifty2;
    fi
    
    echo Cropping $cubFile to $cropped
    time_run.sh crop f=$cubFile t=$cropped samp=$shiftx line=$shifty nsamp=$wid nline=$hgt

    if [ "$enlarge" != "1" ]; then
        echo Enlarging $cropped to $scaled
        time_run.sh enlarge FROM = $cropped TO = $scaled interp = CUBICCONVOLUTION sscale=$enlarge lscale=$enlarge
        cropped=$scaled
    fi
    if [ "$reduce" != "1" ]; then
        echo Reducing $cropped to $scaled
        time_run.sh reduce FROM = $cropped TO = $scaled sscale=$reduce lscale=$reduce
        cropped=$scaled
    fi
    
    # mapproject the cub file
    #time_run.sh cam2map FROM = $cropped MAP = $mapFile TO = $mapped pixres=mpp resolution=$mpp  WARPALGORITHM=forwardpatch patchsize=1
    
    #time_run.sh image2qtree.pl $mapped

    if [ $count -eq 1 ]; then left_crop=$cropped; fi
    if [ $count -eq 2 ]; then right_crop=$cropped; fi

    if [ $count -eq 1 ]; then left_map=$mapped; fi
    if [ $count -eq 2 ]; then right_map=$mapped; fi
    
done

#time_run.sh stereo -s stereo.default --threads 16 $left_map $right_map $res
time_run.sh stereo --subpixel-mode 0 -s stereo.default --threads 16 $left_crop $right_crop $res --subpixel-kernel $sk $sk

time_run.sh point2dem --dem-spacing $spacing --nodata-value -32767 --threads 1 -r moon $res-PC.tif
time_run.sh show_dems.pl $res-DEM.tif
time_run.sh remote_copy.pl $res-DEM.tif $L2
