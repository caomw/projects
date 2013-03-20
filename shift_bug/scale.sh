ls *.ntf | parallel -P 16 dg_mosaic.py {} --output-prefix {.}_sub --reduce-percent 50

