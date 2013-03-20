#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <errno.h>
#include "tif_config.h"
#include "tiffiop.h"
#include "tiffio.h"
int main(int argc, char** argv){

  TIFF *image;
  if((image = TIFFOpen(argv[1], "r")) == NULL){
    fprintf(stderr, "Could not open incoming image\n");
    exit(42);
  }
  printf("Offset of starting strip: %d\n", ((image->tif_dir).td_stripoffset)[0] );

  return 0;
}
