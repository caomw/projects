// __BEGIN_LICENSE__
//  Copyright (c) 2009-2012, United States Government as represented by the
//  Administrator of the National Aeronautics and Space Administration. All
//  rights reserved.
//
//  The NGT platform is licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance with the
//  License. You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// __END_LICENSE__


/// \file point2dem.cc
///
#include <limits>
#include <fstream>
#include <asp/Tools/point2dem.h>

using namespace vw;
using namespace vw::cartography;

#include <asp/Core/OrthoRasterizer.h>
#include <asp/Core/Macros.h>
#include <asp/Core/Common.h>
namespace po = boost::program_options;

#if defined(VW_HAVE_PKG_GDAL) && VW_HAVE_PKG_GDAL==1
#include "ogr_spatialref.h"
#endif

#include <boost/math/special_functions/fpclassify.hpp>

// Allows FileIO to correctly read/write these pixel types
namespace vw {
  template<> struct PixelFormatID<Vector3>   { static const PixelFormatEnum value = VW_PIXEL_GENERIC_3_CHANNEL; };
  template<> struct PixelFormatID<Vector4>   { static const PixelFormatEnum value = VW_PIXEL_GENERIC_4_CHANNEL; };
}

struct Options : asp::BaseOptions {};

int main( int argc, char *argv[] ) {

  // Given a text file with values (lat, lon, height), put these data into a tiff DEM with georeference and no-data values.
  // A lot of the values below are hard-coded.
  //double spacing = 5.0/60.0; // 5 minutes

  std::string in_file    = "latlon_out.txt";
  std::cout << "reading " << in_file << std::endl;

  std::string geoid_file = "/home/oalexan1/projects/base_system/share/geoids/navd88.tif";
  std::cout << "Reading " << geoid_file << std::endl;
  ImageView<float> geoid = DiskImageView<float>(geoid_file);

  // Its georeference is messed up, we will create our own
  GeoReference geoid_georef;
  read_georeference(geoid_georef, geoid_file);

  double nodata_val      = -999;
  Options opt;

  // Read the file again to populate the image
  std::ifstream fh(in_file.c_str());
  double lat, lon, ht;
  while(fh >> lat >> lon >> ht){
    if (ht == nodata_val) continue;

    Vector2 lonlat(lon, lat);

    while ( std::abs(lonlat[1]) > 90.0 ){
      if ( lonlat[1] > 90.0 ){
        lonlat[1] = 180.0 - lonlat[1];
        lonlat[0] += 180.0;
      }
      if ( lonlat[1] < -90.0 ){
        lonlat[1] = -180.0 - lonlat[1];
        lonlat[0] += 180.0;
      }
    }
    while( lonlat[0] <   0.0  ) lonlat[0] += 360.0;
    while( lonlat[0] >= 360.0 ) lonlat[0] -= 360.0;

    Vector2 px = round(geoid_georef.lonlat_to_pixel(lonlat));
    geoid((int)round(px[0]), (int)round(px[1])) = ht;
#if 0
    double ht2 =  geoid((int)round(px[0]), (int)round(px[1]));
    if (ht != ht2){
      std::cout << "error: " << std::endl;
      std::cout << "pix and values: " << px << ' ' << ht2 << ' ' << ht << std::endl;
    }
#endif

  }

  fh.close();

  // Propagate the values to the padding
  for (int col = 0; col < geoid.cols(); col++){
    for (int row = 0; row < geoid.rows(); row++){
      Vector2 pix2(col, row);
      Vector2 lonlat = geoid_georef.pixel_to_lonlat(pix2);

      // Need to carefully wrap lonlat to the [0, 360) x [-90, 90) box.
      // Note that lon = 25, lat = 91 is the same as lon = 180 + 25, lat = 89
      // as we go through the North pole and show up on the other side.
      while ( std::abs(lonlat[1]) > 90.0 ){
        if ( lonlat[1] > 90.0 ){
          lonlat[1] = 180.0 - lonlat[1];
          lonlat[0] += 180.0;
        }
        if ( lonlat[1] < -90.0 ){
          lonlat[1] = -180.0 - lonlat[1];
          lonlat[0] += 180.0;
        }
      }
      while( lonlat[0] <   0.0  ) lonlat[0] += 360.0;
      while( lonlat[0] >= 360.0 ) lonlat[0] -= 360.0;

      Vector2 pix = round(geoid_georef.lonlat_to_pixel(lonlat));
      int c = (int)pix[0];
      int r = (int)pix[1];
      if (r == row && c == col) continue;

      geoid(col, row) = geoid(c, r);

    }
  }


  std::string out_geoid = "out_geoid.tif";
  vw_out() << "Writing: " << out_geoid << std::endl;

  double out_nodata_val = -32767;
  boost::scoped_ptr<DiskImageResourceGDAL> rsrc(asp::build_gdal_rsrc(out_geoid,
                                                                     geoid, opt));
  rsrc->set_nodata_write( out_nodata_val );
  write_georeference( *rsrc, geoid_georef );
  block_write_image( *rsrc, geoid,
                       TerminalProgressCallback("asp", "\t--> Writing DEM: ") );

#if 0
  //Verification
  DiskImageResourceGDAL dem_rsrc(geoid_file);
  double nodata_val_verif = 0;
  if ( dem_rsrc.has_nodata_read() ) {
    nodata_val_verif = dem_rsrc.nodata_read();
    vw_out() << "\tFound input nodata value for DEM: " << nodata_val_verif << std::endl;
  }

  DiskImageView<double> dem_img(dem_rsrc);
  GeoReference dem_georef;
  read_georeference(dem_georef, dem_rsrc);

  Vector2 pix(0, 0);
  Vector2 lonlat = dem_georef.pixel_to_lonlat(pix);
  std::cout << "lat lon value is: " << lonlat[1] << ' ' << lonlat[0] << ' '
            << dem_img((int)pix[0], (int)pix[1]) << std::endl;

  std::string file_check = "latlon_check.txt";
  std::cout << "Will write: " << file_check << std::endl;
  std::ofstream fh_check(file_check.c_str());
  fh_check.precision(20);
  for (int col = 0; col < dem_img.cols(); col++){
    for (int row = dem_img.rows() - 1; row >= 0; row--){
      Vector2 pix(col, row);
      Vector2 lonlat = dem_georef.pixel_to_lonlat(pix);
      fh_check << lonlat[1] << ' ' << lonlat[0] << ' ' << dem_img(col, row) << std::endl;
    }
  }
  fh_check.close();
#endif


  return 0;
}
