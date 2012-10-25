#!/bin/bash

img=$1

$HOME/projects/base_system/bin/gdal_translate -scale 0 1 0 255 $img tmp.tif
$HOME/projects/base_system/bin/gdal_translate -ot Byte tmp.tif $img

