gcc -DHAVE_CONFIG_H -I. -I../libtiff  -I../libtiff   -g -O2 -Wall -W -MT read_tif.o -MD -MP -MF .deps/read_tif.Tpo -c -o read_tif.o read_tif.c
mv -f .deps/read_tif.Tpo .deps/read_tif.Po
/bin/sh ../libtool  --tag=CC   --mode=link gcc  -g -O2 -Wall -W   -o read_tif read_tif.o ../libtiff/libtiff.la ../port/libport.la -ljpeg -lz -lm
libtool: link: gcc -g -O2 -Wall -W -o .libs/read_tif read_tif.o  ../libtiff/.libs/libtiff.so ../port/.libs/libport.a -ljpeg -lz -lm -Wl,-rpath -Wl,/home/oalexan1/projects/packages/lib
