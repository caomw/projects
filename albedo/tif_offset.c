#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <errno.h>
#include "tif_config.h"
#include "tiffiop.h"
#include "tiffio.h"

// Find the byte index in the tif file where the data bytes start.  We
// assume the tif file has 1 byte pixels, 1 band, and no funny
// business.  Such a tif can be obtained for example with vanilla
// gdal_translate, with no special options.

// To compile and run:
/*

export LD_LIBRARY_PATH=$(pwd)/tiff-4.0.3/libtiff/.libs/
gcc -g -O2 -Wall -W -o tif_offset tif_offset.c -I./tiff-4.0.3/libtiff/ ./tiff-4.0.3/libtiff/.libs/libtiff.so ./tiff-4.0.3/port/.libs/libport.a -ljpeg -lz -lm
./tif_offset AMCAM_000E06SA.tif 2>/dev/null

*/

int main(int argc, char** argv){

  TIFF *image;
  if(argc < 2 || (image = TIFFOpen(argv[1], "r")) == NULL){
    fprintf(stderr, "Could not open incoming image\n");
    exit(42);
  }
  printf("Offset of starting strip: %d\n", (int)((image->tif_dir).td_stripoffset)[0] );

  return 0;
}
