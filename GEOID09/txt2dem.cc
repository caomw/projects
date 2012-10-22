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

enum ProjectionType {
  SINUSOIDAL,
  MERCATOR,
  TRANSVERSEMERCATOR,
  ORTHOGRAPHIC,
  STEREOGRAPHIC,
  LAMBERTAZIMUTHAL,
  UTM,
  PLATECARREE
};

struct Options : asp::BaseOptions {
  // Input
  std::string pointcloud_filename, texture_filename;

  // Settings
  float dem_spacing, nodata_value;
  double semi_major, semi_minor;
  std::string reference_spheroid;
  double phi_rot, omega_rot, kappa_rot;
  std::string rot_order;
  double proj_lat, proj_lon, proj_scale;
  double x_offset, y_offset, z_offset;
  size_t utm_zone;
  ProjectionType projection;
  bool has_nodata_value, has_alpha, do_normalize, do_error, no_dem;
  std::string target_srs_string;
  BBox2 target_projwin;
  BBox2i target_projwin_pixels;
  uint32 fsaa;

  // Output
  std::string  out_prefix, output_file_type;

  // Defaults that the user doesn't need to see. (The Magic behind the
  // curtain).
  Options() : semi_major(0), semi_minor(0), fsaa(1) {}
};

void handle_arguments( int argc, char *argv[], Options& opt ) {
  po::options_description manipulation_options("Manipulation options");
  manipulation_options.add_options()
    ("x-offset", po::value(&opt.x_offset)->default_value(0), "Add a horizontal offset to the DEM")
    ("y-offset", po::value(&opt.y_offset)->default_value(0), "Add a horizontal offset to the DEM")
    ("z-offset", po::value(&opt.z_offset)->default_value(0), "Add a vertical offset to the DEM")
    ("rotation-order", po::value(&opt.rot_order)->default_value("xyz"),"Set the order of an euler angle rotation applied to the 3D points prior to DEM rasterization")
    ("phi-rotation", po::value(&opt.phi_rot)->default_value(0),"Set a rotation angle phi")
    ("omega-rotation", po::value(&opt.omega_rot)->default_value(0),"Set a rotation angle omega")
    ("kappa-rotation", po::value(&opt.kappa_rot)->default_value(0),"Set a rotation angle kappa");

  po::options_description projection_options("Projection options");
  projection_options.add_options()
    ("t_srs", po::value(&opt.target_srs_string), "Target spatial reference set. This mimicks the gdal option.")
    ("t_projwin", po::value(&opt.target_projwin), "Selects a subwindow from the source image for copying but with the corners given in georeferenced coordinates. Max is exclusive.")
    ("tr", po::value(&opt.dem_spacing)->default_value(0.0),
     "Set output file resolution (in target georeferenced units per pixel). This is the same as the dem-spacing option.")
    ("reference-spheroid,r", po::value(&opt.reference_spheroid),"Set a reference surface to a hard coded value (one of [ earth, moon, mars].  This will override manually set datum information.")
    ("semi-major-axis", po::value(&opt.semi_major),"Set the dimensions of the datum.")
    ("semi-minor-axis", po::value(&opt.semi_minor),"Set the dimensions of the datum.")
    ("sinusoidal", "Save using a sinusoidal projection")
    ("mercator", "Save using a Mercator projection")
    ("transverse-mercator", "Save using a transverse Mercator projection")
    ("orthographic", "Save using an orthographic projection")
    ("stereographic", "Save using a stereographic projection")
    ("lambert-azimuthal", "Save using a Lambert azimuthal projection")
    ("utm", po::value(&opt.utm_zone), "Save using a UTM projection with the given zone")
    ("proj-lat", po::value(&opt.proj_lat)->default_value(0),
     "The center of projection latitude (if applicable)")
    ("proj-lon", po::value(&opt.proj_lon)->default_value(0),
     "The center of projection longitude (if applicable)")
    ("proj-scale", po::value(&opt.proj_scale)->default_value(0),
     "The projection scale (if applicable)")
    ("dem-spacing,s", po::value(&opt.dem_spacing)->default_value(0.0),
     "Set the DEM post size (if this value is 0, the post spacing size is computed for you)");

  po::options_description general_options("General Options");
  general_options.add_options()
    ("nodata-value", po::value(&opt.nodata_value),
     "Nodata value to use on output. This is the same as default-value.")
    ("use-alpha", po::bool_switch(&opt.has_alpha)->default_value(false),
     "Create images that have an alpha channel")
    ("normalized,n", po::bool_switch(&opt.do_normalize)->default_value(false),
     "Also write a normalized version of the DEM (for debugging)")
    ("orthoimage", po::value(&opt.texture_filename), "Write an orthoimage based on the texture file given as an argument to this command line option")
    ("errorimage", po::bool_switch(&opt.do_error)->default_value(false), "Write a triangule error image.")
    ("fsaa", po::value(&opt.fsaa)->implicit_value(3), "Oversampling amount to perform antialiasing.")
    ("output-prefix,o", po::value(&opt.out_prefix), "Specify the output prefix.")
    ("output-filetype,t", po::value(&opt.output_file_type)->default_value("tif"), "Specify the output file")
    ("no-dem", po::bool_switch(&opt.no_dem)->default_value(false), "Skip writing a DEM.");
  general_options.add( manipulation_options );
  general_options.add( projection_options );
  general_options.add( asp::BaseOptionsDescription(opt) );

  po::options_description positional("");
  positional.add_options()
    ("input-file", po::value(&opt.pointcloud_filename), "Input Point Cloud");

  po::positional_options_description positional_desc;
  positional_desc.add("input-file", 1);

  std::string usage("<point-cloud> ...");
  po::variables_map vm =
    asp::check_command_line( argc, argv, opt, general_options, general_options,
                             positional, positional_desc, usage );

  if ( opt.pointcloud_filename.empty() )
    vw_throw( ArgumentErr() << "Missing point cloud.\n"
              << usage << general_options );
  if ( opt.out_prefix.empty() )
    opt.out_prefix =
      prefix_from_pointcloud_filename( opt.pointcloud_filename );

  boost::to_lower( opt.reference_spheroid );
  if ( vm.count("sinusoidal") )          opt.projection = SINUSOIDAL;
  else if ( vm.count("mercator") )       opt.projection = MERCATOR;
  else if ( vm.count("transverse-mercator") ) opt.projection = TRANSVERSEMERCATOR;
  else if ( vm.count("orthographic") )   opt.projection = ORTHOGRAPHIC;
  else if ( vm.count("stereographic") )  opt.projection = STEREOGRAPHIC;
  else if ( vm.count("lambert-azimuthal") ) opt.projection = LAMBERTAZIMUTHAL;
  else if ( vm.count("utm") )            opt.projection = UTM;
  else                                   opt.projection = PLATECARREE;
  opt.has_nodata_value = vm.count("nodata-value");
}


bool read_user_datum( Options const& opt,
                      cartography::Datum& datum ) {
  // Select a cartographic datum. There are several hard coded datums
  // that can be used here, or the user can specify their own.
  if ( opt.reference_spheroid != "" ) {
    if (opt.reference_spheroid == "mars") {
      datum.set_well_known_datum("D_MARS");
      vw_out() << "\t--> Re-referencing altitude values using standard MOLA\n";
    } else if (opt.reference_spheroid == "moon") {
      datum.set_well_known_datum("D_MOON");
      vw_out() << "\t--> Re-referencing altitude values using standard lunar\n";
    } else if (opt.reference_spheroid == "earth") {
      vw_out() << "\t--> Re-referencing altitude values using WGS84\n";
    } else {
      vw_throw( ArgumentErr() << "\t--> Unknown reference spheriod: "
                << opt.reference_spheroid
                << ". Current options are [ earth, moon, mars ]\nExiting." );
    }
    vw_out() << "\t    Axes [" << datum.semi_major_axis() << " " << datum.semi_minor_axis() << "] meters\n";
  } else if (opt.semi_major != 0 && opt.semi_minor != 0) {
    vw_out() << "\t--> Re-referencing altitude values to user supplied datum.\n"
             << "\t    Semi-major: " << opt.semi_major << "  Semi-minor: " << opt.semi_minor << "\n";
    datum = cartography::Datum("User Specified Datum",
                               "User Specified Spheroid",
                               "Reference Meridian",
                               opt.semi_major, opt.semi_minor, 0.0);
  } else {
    return false;
  }
  return true;
}

int main( int argc, char *argv[] ) {

  // Given a text file with values (lat, lon, height), put these data into a tiff DEM with georeference and no-data values.
  // A lot of the values below are hard-coded.
  double spacing         = 5.0/60.0; // 5 minutes
  std::string in_file    = "latlon_out.txt";
  std::string geoid_file = "NAVD88.tif";
  double nodata_val      = -999;
  
  Options opt;
  try {
    handle_arguments( argc, argv, opt );
    
    // Set up the georeferencing information.  We specify everything
    // here except for the affine transform, which is defined later once
    // we know the bounds of the orthorasterizer view.  However, we can
    // still reproject the points in the point image without the affine
    // transform because this projection never requires us to convert to
    // or from pixel space.
    GeoReference georef;

    // If the data was left in cartesian coordinates, we need to give
    // the DEM a projection that uses some physical units (meters),
    // rather than lon, lat.  This is actually mainly for compatibility
    // with Viz, and it's sort of a hack, but it's left in for the time
    // being.
    //
    // Otherwise, we honor the user's requested projection and convert
    // the points if necessary.
    if (opt.target_srs_string.empty()) {

      cartography::Datum datum;
      if ( read_user_datum( opt, datum ) )
        georef.set_datum( datum );

      switch( opt.projection ) {
      case SINUSOIDAL:
        georef.set_sinusoidal(opt.proj_lon); break;
      case MERCATOR:
        georef.set_mercator(opt.proj_lat,opt.proj_lon,opt.proj_scale); break;
      case TRANSVERSEMERCATOR:
        georef.set_transverse_mercator(opt.proj_lat,opt.proj_lon,opt.proj_scale); break;
      case ORTHOGRAPHIC:
        georef.set_orthographic(opt.proj_lat,opt.proj_lon); break;
      case STEREOGRAPHIC:
        georef.set_stereographic(opt.proj_lat,opt.proj_lon,opt.proj_scale); break;
      case LAMBERTAZIMUTHAL:
        georef.set_lambert_azimuthal(opt.proj_lat,opt.proj_lon); break;
      case UTM:
        georef.set_UTM( opt.utm_zone ); break;
      default: // Handles plate carree
        break;
      }
    } else {
      // Use the target_srs_string
#if defined(VW_HAVE_PKG_GDAL) && VW_HAVE_PKG_GDAL==1

      // User convenience, convert 'IAU2000:' to 'DICT:IAU2000.wkt,'
      boost::replace_first(opt.target_srs_string,
                           "IAU2000:","DICT:IAU2000.wkt,");

      // See if the user specified the datum outside of the target srs
      // string. If they did ... read it and convert to a proj4 string
      // so GDAL won't default to WGS84.
      cartography::Datum user_datum;
      bool have_user_datum = read_user_datum( opt, user_datum );
      if ( have_user_datum ) {
        if ( boost::starts_with(opt.target_srs_string,"+proj") ) {
          opt.target_srs_string += " " + user_datum.proj4_str();
        } else {
          vw_throw(ArgumentErr() << "Can't specify a reference sphere when using target srs string that already specifies a datum." );
        }
      }

      VW_OUT(DebugMessage,"asp") << "Asking GDAL to decypher: \""
                                 << opt.target_srs_string << "\"\n";
      OGRSpatialReference gdal_spatial_ref;
      if (gdal_spatial_ref.SetFromUserInput( opt.target_srs_string.c_str() ))
        vw_throw( ArgumentErr() << "Failed to parse: \"" << opt.target_srs_string << "\"." );
      char *wkt = NULL;
      gdal_spatial_ref.exportToWkt( &wkt );
      std::string wkt_string(wkt);
      delete[] wkt;

      georef.set_wkt( wkt_string );

      // Re-apply the user's datum. The important values were already
      // there (major/minor axis), we're just re-applying to make sure
      // the names of the datum are there.
      if ( have_user_datum ) {
        georef.set_datum( user_datum );
      }
#else
      vw_throw( NoImplErr() << "Target SRS option is not available without GDAL support. Please rebuild VW and ASP with GDAL." );
#endif
    }

    // Find min and max
    std::ifstream fh(in_file.c_str());
    double big = std::numeric_limits<double>::max();
    double lat_min = big, lat_max = -big;
    double lon_min = big, lon_max = -big;
    double lat, lon, ht;
    while(fh >> lat >> lon >> ht){
      if (lat < lat_min) lat_min = lat; if (lat > lat_max) lat_max = lat;
      if (lon < lon_min) lon_min = lon; if (lon > lon_max) lon_max = lon;
    }
    fh.close();

    vw::Matrix<double,3,3> geo_transform;
    geo_transform.set_identity();
    geo_transform(0,0) = spacing;
    geo_transform(1,1) = -spacing;
    geo_transform(0,2) = lon_min;
    geo_transform(1,2) = lat_max;
    
    // Now we are ready to specify the affine transform.
    georef.set_transform(geo_transform);
    std::cout << "georef is " << georef << std::endl;

    // Fix have pixel offset required if pixel_interpretation is
    // PixelAsArea. We could have done that earlier ... but it makes
    // the above easier to not think about it.
    if ( georef.pixel_interpretation() ==
         cartography::GeoReference::PixelAsArea ) {
      Matrix3x3 transform = georef.transform();
      transform(0,2) -= 0.5 * transform(0,0);
      transform(1,2) -= 0.5 * transform(1,1);
      georef.set_transform( transform );
    }

    int num_cols = (int)round((lon_max - lon_min)/spacing) + 1;
    int num_rows = (int)round((lat_max - lat_min)/spacing) + 1;
    std::cout << "cols and rows: " << num_cols << ' ' << num_rows << std::endl;

    std::cout << "lon min and max: " << lon_min << ' ' << lon_max << std::endl;
    std::cout << "lat min and max: " << lat_min << ' ' << lat_max << std::endl;
    
    // Read the file again to populate the image
    std::ifstream fh2(in_file.c_str());
    ImageView<double> geoid_dem(num_cols, num_rows);
    while(fh2 >> lat >> lon >> ht){
      // We assume the lower-left column is first
      int col = (int)round((lon - lon_min)/spacing);
      int row = (int)round((lat - lat_min)/spacing);
      if (col < 0 || col >= num_cols) std::cerr << "out of bounds in col" << std::endl; 
      if (row < 0 || row >= num_rows) std::cerr << "out of bounds in row" << std::endl; 
      geoid_dem(col, num_rows - 1 - row) = ht;
    }
    fh2.close();
    
    vw_out() << "Writing: " << geoid_file << std::endl;

    boost::scoped_ptr<DiskImageResourceGDAL> rsrc(asp::build_gdal_rsrc(geoid_file,
                                                                       geoid_dem, opt));
    rsrc->set_nodata_write( nodata_val );
    write_georeference( *rsrc, georef );
    block_write_image( *rsrc, geoid_dem,
                       TerminalProgressCallback("asp", "\t--> Writing DEM: ") );

#if 1
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
    
  } ASP_STANDARD_CATCHES;
  
  return 0;
}
