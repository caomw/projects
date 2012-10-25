for ((l = 6; l < 11; l++)); do
  export LOCAL=1; export WRITE=0; 
  time plate2kml $CTX -o test$l -p mars -l $l -n 1 -i 0
  ~/packages/bin/pprof --text /home/oalexandrov/visionworkbench/src/vw/Plate/.libs/lt-plate2kml /tmp/cpuprofile > profiled$l.txt 2>&1
done

