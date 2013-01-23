#!/bin/bash

RUN=run4

# for d in results_1mpp*"$RUN"; do
#     echo Rm empty in $d
#     rm_empty.pl $d
# done

for d in results_1mpp*"$RUN"; do
    echo $d;
    files=$(ls $d/LRONAC_DRG_*.tif)
    for DRG in $files; do
        echo " "
        DRG=${DRG/DRG/DRG};             if [ ! -e $DRG ];      then echo Missing $DRG;       exit; fi
        DEM=${DRG/DRG/DEM};             if [ ! -e $DEM ];      then echo Missing $DEM;       exit; fi
        DEMError=${DRG/DRG/DEMError};   if [ ! -e $DEMError ]; then echo Missing $DEMError;  exit; fi
        #hillshade=${DRG/DRG/hillshade};if [ ! -e $hillshade ];then echo Missing $hillshade; exit; fi
        echo $DRG $DEM $DEMError #$hillshade
        
    done
done

# for d in results_1mpp*"$RUN"; do
#     echo $d;
#     files=$(ls $d/LRONAC_hillshade*.tif)
#     for hillshade in $files; do
#         echo " "
#         DRG=${hillshade/hillshade/DRG}
#         DEM=${hillshade/hillshade/DEM}
#         DEMError=${hillshade/hillshade/DEMError}
#         echo  $hillshade $DRG $DEM $DEMError
#         if [ ! -e $DRG ]; then
#             echo Missing $DRG
# #             rm -fv $DRG
# #             rm -fv $DEM
# #             rm -fv $DEMError
# #             rm -fv $hillshade
#         fi
#     done
# done

# for d in results_1mpp*"$RUN"; do
#     echo $d;
#     files=$(ls $d/LRONAC_hillshade*.tif)
#     for hillshade in $files; do
#         echo " "
#         DEMError=${hillshade/hillshade/DEMError}
#         base=${DEMError/.tif/}
#         if [ ! -e $DEMError ]; then echo Missing $DEMError; exit
#         fi
#         fNorth=$base"_North_sigma1.tif"; if [ ! -e $fNorth ]; then echo Missing $fNorth for $DEMError; exit; fi
#         fEast=$base"_East_sigma1.tif";   if [ ! -e $fEast  ]; then echo Missing $fEast  for $DEMError; exit; fi
#         fDown=$base"_Down_sigma1.tif";   if [ ! -e $fDown  ]; then echo Missing $fDown  for $DEMError; exit; fi
#     done
# done

for d in results_1mpp*"$RUN"; do
    echo $d;
    DRG=$(ls $d/LRONAC_DRG_*.tif | wc | print_col.pl 1)
    DEM=$(ls $d/LRONAC_DEM_*.tif | wc | print_col.pl 1)
    DEMError=$(ls $d/LRONAC_DEMError_*.tif | wc | print_col.pl 1)
    echo Number of files: DRG=$DRG DEM=$DEM DEMError=$DEMError
    if [ "$DRG" -ne "$DEM" ] || [ "$DRG" -ne "$DEMError" ]; then
        echo "ERROR: Cannot find the right number of files!"
        exit
    fi
done

# for d in results_1mpp*"$RUN"; do
#     base=$(ls $d/LRONAC_DEMError*.tif | grep -v -E "North|East|Down" | wc| print_col.pl 1)
#     derived=$(ls $d/LRONAC_DEMError*.tif | grep -E "North|East|Down" | wc| print_col.pl 1)

#     echo $base $derived
#     ((derived2 = 3*base));
#     if [ $derived2 -eq $derived ]; then
#         echo good
#     else
#         echo $d
#         echo "ERROR: Cannot find the right number of derived DEM errors!"
#         exit
#     fi
# done

echo " - ls results_1mpp*$RUN/LRONAC_DRG_*.tif"
echo " - ls results_1mpp*$RUN/LRONAC_DEM_*.tif"
echo " - ls results_1mpp*$RUN/LRONAC_DEMError_*.tif"
#echo " - ls results_1mpp*$RUN/LRONAC_hillshade_*.tif"

# pct=10
# ((sub=100/pct))

# time_run.sh gdalbuildvrt -srcnodata 0 resolve_DRG_"$RUN".tif results_1mpp*"$RUN"/LRONAC_DRG_*.tif
# time_run.sh gdal_translate -outsize $pct% $pct%  resolve_DRG_"$RUN".tif resolve_DRG_"$RUN"_sub"$sub".tif
# time_run.sh image2qtree.pl resolve_DRG_"$RUN"_sub"$sub".tif

# time_run.sh gdalbuildvrt resolve_DEM_"$RUN".tif results_1mpp*"$RUN"/LRONAC_DEM_*.tif
# time_run.sh gdal_translate -outsize $pct% $pct%  resolve_DEM_"$RUN".tif resolve_DEM_"$RUN"_sub"$sub".tif
# time_run.sh show_dems.pl resolve_DEM_"$RUN"_sub"$sub".tif
