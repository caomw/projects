#ifndef GNUPLOTSCRIPT_H
#define GNUPLOTSCRIPT_H
#include <string>

inline std::string createGnuplotScript(std::string dataFileName, std::string imgFileName,
                                       std::string filePath1, std::string filePath2, std::string filePath3){
  
  return
    "dataFile  = '" + dataFileName + "'\n" +
    "imgFile   = '" + imgFileName  + "'\n" +
    "filePath1 = '" + filePath1    + "'\n" +
    "filePath2 = '" + filePath2    + "'\n" +
    "filePath3 = '" + filePath3    + "'\n" +
"\n"
" set terminal png size 1200, 900; set output imgFile\n"
"#set terminal pdfcairo;           set output 'fig.pdf'\n"
"\n"
"set multiplot  # get into multiplot mode\n"
"set nokey      # no legend\n"
"set grid\n"
"\n"
"set datafile missing 'nan'\n"
"\n"
"w3 = 1.0/3.0; # will do 3 columns of plots\n"
"set size w3, w3\n"
"\n"
"set title filePath1\n"
"set origin 0,    2*w3\n"
"plot dataFile using 4:5 with points pointtype 7 pointsize 0.6 lc rgb 'red', dataFile using 1:6 with lines lc rgb 'green', dataFile using 1:7 with lines lc rgb 'yellow'\n"
"\n"
"set title filePath2\n"
"set origin w3,   2*w3\n"
"plot dataFile using 11:12 with points pointtype 7 pointsize 0.6 lc rgb 'red', dataFile using 1:13 with lines lc rgb 'green', dataFile using 1:14 with lines lc rgb 'yellow'\n"
"\n"
"set title filePath3\n"
"set origin 2*w3, 2*w3\n"
"plot dataFile using 18:19 with points pointtype 7 pointsize 0.6 lc rgb 'red', dataFile using 1:20 with lines lc rgb 'green', dataFile using 1:21 with lines lc rgb 'yellow'\n"
"\n"
"set title ''\n"
"set origin 0,     w3\n"
"plot dataFile using 4:8 with points pointtype 7 pointsize 0.6 lc rgb 'red', dataFile using 1:9 with lines lc rgb 'green', dataFile using 1:10 with lines lc rgb 'yellow'\n"
"\n"
"set title ''\n"
"set origin w3,    w3\n"
"plot dataFile using 11:15 with points pointtype 7 pointsize 0.6 lc rgb 'red', dataFile using 1:16 with lines lc rgb 'green', dataFile using 1:17 with lines lc rgb 'yellow'\n"
"\n"
"set title ''\n"
"set origin 2*w3,  w3\n"
"plot dataFile using 18:22 with points pointtype 7 pointsize 0.6 lc rgb 'red', dataFile using 1:23 with lines lc rgb 'green', dataFile using 1:24 with lines lc rgb 'yellow'\n"
"\n"
"w2 = 0.5 # 1/2 of the plotting window\n"
"set size w2, w3\n"
"\n"
"set title 'Cross-track Jitter'\n"
"set origin 0,     0\n"
"plot dataFile using 1:2 with lines lc rgb 'blue'\n"
"\n"
"set title 'Down-track Jitter'\n"
"set origin w2,    0\n"
"plot dataFile using 1:3 with lines lc rgb 'blue'\n"
"\n"
"unset multiplot # exit multiplot mode\n"
"";

}

#endif
