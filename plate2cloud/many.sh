for ((l=5; l<=11; l++)); do 
  ./benchmarck.sh $l > output$l.txt 2>&1
done


