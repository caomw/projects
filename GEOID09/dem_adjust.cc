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

/// \file dem_adjust.cc
///

#include <vw/FileIO.h>
#include <vw/Image.h>
#include <vw/Cartography.h>
#include <vw/Math.h>
#include <asp/Core/Macros.h>
#include <asp/Core/Common.h>
#include <GeographicLib/Geoid.hpp>

#include <asp/Core/OrthoRasterizer.h>
#include <asp/Core/Macros.h>
#include <asp/Core/Common.h>

using namespace vw;
using namespace asp;
using namespace vw::cartography;
namespace po = boost::program_options;
namespace fs = boost::filesystem;

using std::endl;
using std::string;
using namespace vw;
using namespace vw::cartography;
using namespace GeographicLib;

template <class ImageT>
class AdjustDemView : public ImageViewBase<AdjustDemView<ImageT> >
{
  ImageT m_img;
  GeoReference const& m_georef;
  Geoid const& m_geoid;
  double m_nodata_val;

public:

  typedef double pixel_type;
  typedef double result_type;
  typedef ProceduralPixelAccessor<AdjustDemView> pixel_accessor;

  AdjustDemView(ImageT const& img, GeoReference const& georef, Geoid const& geoid, double nodata_val):
    m_img(img), m_georef(georef), m_geoid(geoid), m_nodata_val(nodata_val){}

  inline int32 cols() const { return m_img.cols(); }
  inline int32 rows() const { return m_img.rows(); }
  inline int32 planes() const { return 1; }

  inline pixel_accessor origin() const { return pixel_accessor(*this); }

  inline result_type operator()( size_t col, size_t row, size_t p=0 ) const {
    
    if ( m_img(col, row, p) == m_nodata_val ) return m_nodata_val;
    
    Vector2     lonlat                 = m_georef.pixel_to_lonlat(Vector2(col, row));
    result_type geoid_height           = m_geoid(lonlat[1], lonlat[0]);
    result_type height_above_ellipsoid = m_img(col, row, p);
    result_type height_above_geoid     = height_above_ellipsoid - Geoid::GEOIDTOELLIPSOID * geoid_height;
    return height_above_geoid;
  }
  
  /// \cond INTERNAL
  typedef AdjustDemView<typename ImageT::prerasterize_type> prerasterize_type;
  inline prerasterize_type prerasterize( BBox2i const& bbox ) const { return prerasterize_type( m_img.prerasterize(bbox), m_georef, m_geoid, m_nodata_val ); }
  template <class DestT> inline void rasterize( DestT const& dest, BBox2i const& bbox ) const { vw::rasterize( prerasterize(bbox), dest, bbox ); }
  /// \endcond
};

template <class ImageT>
AdjustDemView<ImageT>
adjust_dem( ImageViewBase<ImageT> const& img, GeoReference const& georef, Geoid const& geoid, double nodata_val) {
  return AdjustDemView<ImageT>( img.impl(), georef, geoid, nodata_val );
}

struct Options : asp::BaseOptions {
  string dem_name, output_prefix;
  double nodata_value;
  bool use_float;
};

void handle_arguments( int argc, char *argv[], Options& opt ){
  
  po::options_description general_options("");
  general_options.add_options()
    ("nodata_value", po::value(&opt.nodata_value)->default_value(-32767),
     "The value of no-data pixels, unless specified in the DEM.")
    ("output-prefix,o", po::value(&opt.output_prefix), "Specify the output prefix.")
    ("float", po::bool_switch(&opt.use_float)->default_value(false), "Output using float (32 bit) instead of using doubles (64 bit).");

  general_options.add( asp::BaseOptionsDescription(opt) );
  
  po::options_description positional("");
  positional.add_options()
    ("dem", po::value(&opt.dem_name), "Explicitly specify the DEM.");

  po::positional_options_description positional_desc;
  positional_desc.add("dem", 1);

  std::string usage("[options] <dem>");
  po::variables_map vm =
    asp::check_command_line( argc, argv, opt, general_options, general_options,
                             positional, positional_desc, usage );

  if ( opt.dem_name.empty() )
    vw_throw( ArgumentErr() << "Requires <dem> in order to proceed.\n\n" << usage << general_options );

  if ( opt.output_prefix.empty() ) {
    opt.output_prefix = fs::basename(opt.dem_name);
  }
}

int main( int argc, char *argv[] ) {

  // Adjust the DEM values so that they are relative to the geoid
  // rather than to the ellipsoid.

  double spacing = atof(argv[2]);
  argc--;
  std::cout << "--- spacing is " << spacing << std::endl;
  
  Options opt;
  try {
    handle_arguments( argc, argv, opt );
    std::cout.precision(20);

    Geoid egm96("egm96-5");

    std::string navd_file = "NAVD88.tif";

    std::string geoid96_file = "egm96-5.tif";
    std::cout << "Reading " << geoid96_file << std::endl;
    DiskImageResourceGDAL dem_rsrc(geoid96_file);
    double nodata_value = -32767;
    if ( dem_rsrc.has_nodata_read() ) {
      nodata_value = dem_rsrc.nodata_read();
      vw_out() << "\tFound input nodata value for DEM: " << nodata_value << std::endl;
    }
    std::cout << "nodata is " << nodata_value << std::endl;
    
    DiskImageView<double> dem_img(dem_rsrc);
    GeoReference dem_georef;
    read_georeference(dem_georef, dem_rsrc);

#if 1

    std::cout << "Reading " << navd_file << std::endl;
    DiskImageResourceGDAL dem_navd_rsrc(navd_file);
    if ( dem_navd_rsrc.has_nodata_read() ) {
      nodata_value = dem_navd_rsrc.nodata_read();
      vw_out() << "\tFound input nodata value for DEM_NAVD: " << nodata_value << std::endl;
    }
    std::cout << "nodata is " << nodata_value << std::endl;
    
    DiskImageView<double> dem_navd_img(dem_navd_rsrc);
    GeoReference dem_navd_georef;
    read_georeference(dem_navd_georef, dem_navd_rsrc);

    ImageViewRef<PixelMask<double> > dem_navd
      = interpolate(create_mask( dem_navd_img, nodata_value ),
                    BicubicInterpolation(), ZeroEdgeExtension());
    
    //240 38 Vector2(2885,629) -25.89739990234375
    //240 38.166666666666699825 Vector2(2885,626.99999999999954525) -25.158399581909179688

    Vector2 pix;

    pix = Vector2(240, 38); std::cout << "pix and value is " << dem_navd(pix[0], pix[1]) << std::endl;

    pix = Vector2(240, 38.16666666666666666666666666);
    std::cout << "pix and value is " << dem_navd(pix[0], pix[1]) << std::endl;

    pix = Vector2(240, 38.04);
    std::cout << "pix and value is " << dem_navd(pix[0], pix[1]) << std::endl;

    exit(0);
    
#endif
    
// //     if ( dem_georef.pixel_interpretation() ==
// //          cartography::Georeference::PixelAsArea ) {
//     Matrix3x3 transform = dem_georef.transform();
//     transform(0,2) += 0.5 * transform(0,0);
//     transform(1,2) += 0.5 * transform(1,1);
//     dem_georef.set_transform( transform );
//     //     }

#if 0
    std::string in_file  = "latlon_out.txt"; // xxx 
    double bad_val       = -999;

    ImageView<float> dem_img3(dem_img.cols(), dem_img.rows());
    for (int col = 0; col < dem_img3.cols(); col++){
      std::cout << "col is " << col << std::endl;
      for (int row = 0; row < dem_img3.rows(); row++){
        dem_img3(col, row) = nodata_value;
      }
    }
    
    std::ifstream fh(in_file.c_str());
    double lat, lon, ht;
    while(fh >> lat >> lon >> ht){
      Vector2 pix = dem_georef.lonlat_to_pixel(Vector2(lon, lat));
      if (ht != bad_val){
        std::cout << "lonlat, pix and val: " << lon << ' ' << lat << ' ' << pix << ' ' << ht << std::endl;
        int col = (int)round(pix[0]);
        int row = (int)round(pix[1]);
        dem_img3(col, row) = ht;
      }
    }

    vw_out() << "Writing: " << navd_file << std::endl;

    boost::scoped_ptr<DiskImageResourceGDAL> rsrc(asp::build_gdal_rsrc(navd_file,
                                                                       dem_img3, opt));
    rsrc->set_nodata_write( nodata_value );
    write_georeference( *rsrc, dem_georef );
    block_write_image( *rsrc, dem_img3,
                       TerminalProgressCallback("asp", "\t--> Writing DEM: ") );

    exit(0);
    
#endif
    
#if 0

    std::string geoid96_file_orig = "egm96-5-orig.tif";
    std::cout << "Reading " << geoid96_file_orig << std::endl;

    DiskImageResourceGDAL dem_rsrc_orig(geoid96_file_orig);
    double nodata_value_orig = -32767;
    if ( dem_rsrc_orig.has_nodata_read() ) {
      nodata_value_orig = dem_rsrc_orig.nodata_read();
      vw_out() << "\tFound input nodata value for DEM: " << nodata_value_orig << std::endl;
    }
    std::cout << "nodata is " << nodata_value_orig << std::endl;
    
    GeoReference dem_georef_orig;
    read_georeference(dem_georef_orig, dem_rsrc_orig);
    dem_georef_orig.set_pixel_interpretation( cartography::GeoReference::PixelAsArea );

    DiskImageView<float> dem_img_orig(dem_rsrc_orig);

    int shift = 5; // pad on all sides
    int extra = 20; // pad right
    
    dem_georef_orig = crop(dem_georef_orig, -shift, -shift);
    
    ImageView<float> dem_img_curr(dem_img_orig.cols()+2*shift + extra, dem_img_orig.rows() + 2*shift);
    for (int col = 0; col < dem_img_curr.cols(); col++){
      std::cout << "col is " << col << std::endl;
      for (int row = 0; row < dem_img_curr.rows(); row++){

        Vector2 lonlat = dem_georef_orig.pixel_to_lonlat(Vector2(col, row));
        dem_img_curr(col, row) = egm96(lonlat[1], lonlat[0]);
      }
    }
    
    std::string geoid96_file2 = "egm96-5.tif";

    vw_out() << "Writing: " << geoid96_file2 << std::endl;

    boost::scoped_ptr<DiskImageResourceGDAL> rsrc(asp::build_gdal_rsrc(geoid96_file2,
                                                                       dem_img_curr, opt));
    rsrc->set_nodata_write( nodata_value_orig );
    write_georeference( *rsrc, dem_georef_orig );
    block_write_image( *rsrc, dem_img_curr,
                       TerminalProgressCallback("asp", "\t--> Writing DEM: ") );

    exit(0);
#endif

#if 0
    // Temporary!!!
    DiskImageView<float> dem_img2(dem_rsrc);
    dem_georef.set_pixel_interpretation( cartography::GeoReference::PixelAsArea );

    std::string geoid96_file2 = "egm96-5-2.tif";

    vw_out() << "Writing: " << geoid96_file2 << std::endl;

    boost::scoped_ptr<DiskImageResourceGDAL> rsrc(asp::build_gdal_rsrc(geoid96_file2,
                                                                       dem_img2, opt));
    rsrc->set_nodata_write( nodata_value );
    write_georeference( *rsrc, dem_georef );
    block_write_image( *rsrc, dem_img2,
                       TerminalProgressCallback("asp", "\t--> Writing DEM: ") );

    exit(0);
#endif

#if 0
    ImageViewRef<PixelMask<double> > dem
      = interpolate(create_mask( dem_img, nodata_value ),
                    BicubicInterpolation(), ZeroEdgeExtension());

    double max_err = 0;
    Vector2 max_pix, max_lonlat;
    for (int lon = -10; lon <=380 ; lon++){ 
      std::cout << "lon = " << lon << std::endl;
      for (int lat = -90; lat <= 90; lat++){
        for (double tx = 0; tx < 1.0; tx += spacing){
          for (double ty = 0; ty < 1.0; ty += spacing){
            
            Vector2 lonlat(lon + tx, lat + ty);

            while( lonlat[0] <    0.0 ) lonlat[0] += 360.0;
            while( lonlat[0] >= 360.0 ) lonlat[0] -= 360.0;
            
            if (lonlat[0] < 0.0 || lonlat[0] >= 360.0){

              std::cerr << "Error2!" << std::endl;
              exit(0);
              Vector2 lonlat_orig = lonlat;
              
              int q = (int)floor(lonlat[0]/360.0);
              lonlat[0] -= 360.0*q;

              // Paradoxically, the extra check below is necessary,
              // due to artifacts in floating point rounding.
              if (lonlat[0] < 0.0 || lonlat[0] >= 360.0) lonlat[0] = 0.0;
                
              if (lonlat[0] >= 360.0){  
                std::cerr << "q is " << q << std::endl;
                std::cout << "ratio is " << lonlat_orig[0]/360.0 << std::endl;

                std::cout << "original: " << lonlat_orig << std::endl;
                std::cout << "curr: " << lonlat << std::endl;
                exit(0);
              }
              
              //lonlat[0] -= 360.0*q;
            }
            
            
            if (lonlat[1] > 90.0) lonlat[1] = 90.0;

            //         if (lonlat[1] < 0 || lonlat[1] >= 360.0){
            //           int q = (int)floor(lonlat[1]/360.0.0);
            //           lonlat[1] -= 360.0.0*q;
            //         }

            //for (int t = 0; t <= 10; t++){
            //Vector2 lonlat(240.0033222, 36.9929292292);
            //Vector2 lonlat(240 + t/10.0, 36 + t/10.0);
            double geoid_height = egm96(lonlat[1], lonlat[0]);
            //std::cout << "geographylib: point and geoid: "
            //<< lonlat << ' ' << geoid_height << std::endl;
        
            Vector2 pix = dem_georef.lonlat_to_pixel(lonlat);
            //std::cout << "lonlat and pixel are " << lonlat << ' ' << pix << std::endl;
            //std::cout << "Value from file: " << dem_img((int)pix[0], (int)pix[1]) << std::endl;
            //std::cout << "Value from interp: " << dem(pix[0], pix[1]) << std::endl;
            double interp_val = dem(pix[0], pix[1]);
            double err = std::abs(geoid_height - interp_val);
            if (err > max_err){
              max_err = err;
              max_pix = pix;
              max_lonlat = lonlat;
              std::cout << "lonlat, pix, error: "
                        << lonlat << ' ' << pix << ' '
                        << geoid_height << ' ' << interp_val << ' '
                        << err << std::endl;

//               std::cout << "geoid vals:  " << egm96(lonlat[1], 0)  << ' ' << egm96(lonlat[1], 360) << std::endl;
//               std::cout << "geoid vals2:  " << egm96(lonlat[1], 359.8999999)  << ' ' << egm96(lonlat[1], 359.89999999999997726) << std::endl;
              
//               std::cout << "interp vals: " << dem(0, pix[1]) << " " << dem(360, pix[1]) << std::endl;
              
              
            }
        
          }
        }
      }
    }
    
    std::cout << "max err is " << max_err << " at pixel " << max_pix << " and lonlat " << max_lonlat << std::endl;
#endif
    
  } ASP_STANDARD_CATCHES;

  return 0;
}
