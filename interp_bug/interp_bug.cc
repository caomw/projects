// __BEGIN_LICENSE__
//  Copyright (c) 2006-2012, United States Government as represented by the
//  Administrator of the National Aeronautics and Space Administration. All
//  rights reserved.
//
//  The NASA Vision Workbench is licensed under the Apache License,
//  Version 2.0 (the "License"); you may not use this file except in
//  compliance with the License. You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// __END_LICENSE__

#ifdef _MSC_VER
#pragma warning(disable:4244)
#pragma warning(disable:4267)
#pragma warning(disable:4996)
#endif

#include <cstdlib>
#include <iostream>
#include <cmath>
#include <boost/tokenizer.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/numeric/conversion/cast.hpp>
#include <boost/program_options.hpp>
#include <boost/filesystem/path.hpp>
#include <boost/foreach.hpp>
namespace fs = boost::filesystem;
namespace po = boost::program_options;

#include <vw/Core/Functors.h>
#include <vw/Image/Algorithms.h>
#include <vw/Image/ImageMath.h>
#include <vw/Image/ImageViewRef.h>
#include <vw/Image/PerPixelViews.h>
#include <vw/Image/PixelMask.h>
#include <vw/Image/MaskViews.h>
#include <vw/Image/PixelTypes.h>
#include <vw/Image/Statistics.h>
#include <vw/FileIO/DiskImageView.h>
#include <vw/Cartography/GeoReference.h>
#include <vw/tools/Common.h>
#include <vw/FileIO/DiskImageResourceGDAL.h>
#include <vw/Image/Interpolation.h>
#include <asp/Core/Macros.h>
#include <asp/Core/Common.h>

using namespace vw;
using namespace vw::cartography;

struct Options : asp::BaseOptions {};

// Find the mean and std dev DEM of the given input sets of DEMs

int main( int argc, char *argv[] ){

  Options opt;
  std::string file = "run-DEM.tif";
  std::cout << "Reading: " << file << std::endl;

  DiskImageResourceGDAL in_rsrc(file);
  float nodata_val = -32767;
  if ( in_rsrc.has_nodata_read() ) {
    nodata_val = in_rsrc.nodata_read();
    vw_out() << "\tFound input nodata value: " << nodata_val << std::endl;
  }else{
    std::cerr << "Nodata value not found in: " << file << std::endl;
  }

  GeoReference georef;
  read_georeference(georef, in_rsrc);

  DiskImageView<float> dem(in_rsrc);
  ImageViewRef< PixelMask<float> >  masked_dem = create_mask(dem, nodata_val);

  InterpolationView<EdgeExtensionView< ImageViewRef < PixelMask<float> >, ZeroEdgeExtension>, BicubicInterpolation> masked_dem_interp = interpolate(masked_dem, BicubicInterpolation(), ZeroEdgeExtension());

  std::cout.precision(20);
  std::cout << "cols and rows are " << dem.cols() << ' ' << dem.rows()
            << std::endl;

  int max_count = 10, count = 0;

  int num_valid = 0, num_invalid = 0;
  for (int col = 1; col < dem.cols()-1; col++){
    for (int row = 1; row < dem.rows()-1; row++){
      if (is_valid(masked_dem(col, row))) num_valid++;
      else                                num_invalid++;

      PixelMask<float> px1 = masked_dem(col, row);
      PixelMask<float> px2 = masked_dem_interp(col, row);
      if (px1 != px2){
        count++;
        if (count > max_count) continue;
        std::cout << "different2: " << col << ' ' << row  << ' '
                  << px1 << ' ' << px2 << std::endl;
      }
    }
  }

  std::cout << "count is " << count << std::endl;
  std::cout << "num valid is "   << num_valid   << std::endl;
  std::cout << "num invalid is " << num_invalid << std::endl;

//   // The "if" statement below is to work around a bug in
//   // interpolation with PixelMask.
//   PixelMask<float> val;
//   if (x == col && y == row)
//     val = masked_dem(col, row);
//   else
//     val = masked_dem_interp(x, y);
//   if (!is_valid(val)) continue;
//   interp_val = val.child();

//   mean_dem    (col, row) += interp_val;
//   std_dev_dem (col, row) += interp_val*interp_val;
//   count_dem   (col, row) += 1;

//   std::string mean_file = "mean.tif";
//   std::cout << "Writing: " << mean_file << std::endl;
//   block_write_gdal_image(mean_file, pixel_cast<float>(mean_dem),
//                          georef, nodata_val, opt);

//   std::string std_dev_file = "std_dev.tif";
//   std::cout << "Writing: " << std_dev_file << std::endl;
//   block_write_gdal_image(std_dev_file, pixel_cast<float>(std_dev_dem),
//                          georef, nodata_val, opt);

//   std::string count_file = "count.tif";
//   std::cout << "Writing: " << count_file << std::endl;
//   block_write_gdal_image(count_file, pixel_cast<float>(count_dem),
//                          georef, nodata_val, opt);

  return 0;

}
