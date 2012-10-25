ls -l D*M_input_sub32 | perl -pi -e "s#\busers\s+##g" | awk '{print $5 " " $9}'

