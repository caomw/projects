#!/bin/bash

pct=$1
tag=$2
RUN=run4
((sub=100/pct))
#((p=pct*125/5)); ((q=pct*955/5)); ((r=pct*30/5)); ((s=pct*30/5));
# ((p=pct*110/5)); ((q=pct*940/5)); ((r=pct*45/5)); ((s=pct*45/5));
# ((p=pct*100/5)); ((q=pct*930/5)); ((r=pct*75/5)); ((s=pct*75/5));

# # time_run.sh gdalbuildvrt -srcnodata 0 resolve_DRG_"$RUN".tif results_1mpp*"$RUN"/LRONAC_DRG_*tif
# # time_run.sh gdal_translate -outsize $pct% $pct%  resolve_DRG_"$RUN".tif resolve_DRG_"$RUN"_sub"$sub".tif
# # time_run.sh float2int2.pl resolve_DRG_"$RUN"_sub"$sub".tif resolve_DRG_"$RUN"_sub"$sub""_int".tif 
# # time_run.sh image2qtree.pl resolve_DRG_"$RUN"_sub"$sub""_int".tif

demFile=resolve_DEM_"$RUN"_sub"$sub".tif
if [ ! -e $demFile ]; then 
    time_run.sh gdalbuildvrt resolve_DEM_"$RUN".tif results_1mpp*"$RUN"/LRONAC_DEM_*tif
    time_run.sh gdal_translate -outsize $pct% $pct%  resolve_DEM_"$RUN".tif $demFile
fi
# time_run.sh gdal_translate -srcwin $p $q $r $s $demFile resolve_DEM_"$RUN"_sub"$sub"_"$tag".tif
# time_run.sh show_dems.pl resolve_DEM_"$RUN"_sub"$sub"_"$tag".tif
#echo $demFile
# time_run.sh show_dems.pl $demFile

errPref=resolve_DEMError_"$RUN"_sub"$sub"
if [ ! -e $errPref.tif ]; then 
    time_run.sh gdalbuildvrt resolve_DEMError_"$RUN".tif results_1mpp*"$RUN"/LRONAC_DEMError*tif
    time_run.sh gdal_translate -outsize $pct% $pct% resolve_DEMError_"$RUN".tif $errPref.tif
fi

((b=0))
for f in North East Down; do
    ((b++))
    band=$errPref"_"$f"_"$tag.tif
    fileOut=$errPref"_"$f"_color_"$tag.tif
    time_run.sh gdal_translate -b $b $errPref.tif $band
    #viewq2.sh $band
    echo "---$band"

    if [ $b -eq 1 ]; then mn=2.5; mx=5; fi
    if [ $b -eq 2 ]; then mn=18; mx=28; fi
    if [ $b -eq 3 ]; then mn=0.2; mx=1.5; fi
    time_run.sh colormap --lut-file ara_colormap.lut --min $mn --max $mx $band -o $fileOut
    nohup nice -19 time_run.sh image2qtree.pl $fileOut &

    #fileOut=$(echo $errPref"_"$f.tif | perl -pi -e "s#_sub\d+##g" | perl -pi -e "s#_run\d+##g")
    #time_run.sh colormap --moon --legend --lut-file ara_colormap.lut -s $band -o $fileOut $demFile
done

# # sigma=1
#plot_err.sh $errPref.tif $sigma
# # image2qtree.pl $errPref"_North"_sigma$sigma.tif
# # image2qtree.pl $errPref"_East"_sigma$sigma.tif
# # image2qtree.pl $errPref"_Down"_sigma$sigma.tif

