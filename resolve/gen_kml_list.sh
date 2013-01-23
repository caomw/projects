#!/bin/bash

i=0; for f in $(tac tmp.txt); do g=$(echo $f| perl -pi -e "s#^.*?results_(.*?M.*?M.*?)_.*?\n#\$1#g"); ((i++)); if ((i%4==1)); then echo "* ''' $i [$f $g]'''"; else echo "* $i [$f $g]"; fi; done
