#!/bin/bash

q="";

for ((j=7; j>=0; j--)); do for ((i=9; i>=0; i--)); do q="$q $i"x"$j"; done; done

echo $q | perl -pi -e "s#\s#\n#g" | xargs -P 6 -I {} ./run1.sh {}
