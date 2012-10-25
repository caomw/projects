// This writes an uncompress binary PCD
#include <iostream>
#include <fstream>
#include <vw/Core.h>
#include <vw/Image.h>
#include <vw/FileIO.h>
#include <vw/Cartography.h>

using namespace std;
using namespace vw;

int main( int argc, char**argv ){

  if (argc < 3){
    std::cerr << "Usage: " << argv[0] << " input.tif output.pcd" << std::endl;
    exit(0);
  }
  std::string input_name( argv[1] );
  std::string output_name( argv[2] );
  if ( input_name.empty() ) {
    std::cerr << "Please provide an input file." << std::endl;
    return 1;
  }

  // Open the DEM. We need the following:
  //  Width, Height = 0,
  //  Mean center
  cartography::GeoReference dem_georef;
  cartography::read_georeference( dem_georef, input_name );
  DiskImageView<float> dem( input_name );

  // Convert to cartesian (lazy and recalculated many times)
  ImageViewRef<Vector3> point_cloud =
    geodetic_to_cartesian( dem_to_geodetic( dem, dem_georef ), dem_georef.datum() );
  size_t count = 0;
  Vector3 mean_center;

  vw_out() << "Calculating the number of points in the file!" << std::endl;
  {
    TerminalProgressCallback tpc("","");
    double inc_amount = 1.0 / double(point_cloud.rows() );
    tpc.report_progress(0);
    for (size_t j = 0; j < point_cloud.rows(); j++ ) {
      size_t local_count = 0;
      Vector3 local_mean;
      for ( size_t i = 0; i < point_cloud.cols(); i++ ) {
        Vector3 copy = subvector(point_cloud(i,j),0,3);
        if ( copy != Vector3() && copy == copy ) {
          local_mean += copy;
          local_count++;
        }
      }
      if ( local_count > 0 ) {
        local_mean /= double(local_count);
        double afraction = double(count) / double(count + local_count);
        double bfraction = double(local_count) / double(count + local_count);
        mean_center = afraction*mean_center + bfraction*local_mean;
        count += local_count;
      }
      tpc.report_incremental_progress( inc_amount );
    }
    tpc.report_finished();
  }
  mean_center = Vector3(-2.63289e+06,-4.3668e+06,3.81894e+06);
  std::cout << "Found " << count << " valid points\n";
  std::cout << "Center is " << mean_center << std::endl;

  // Start writing the output
  std::cout << "Will write: " << output_name << std::endl;
  ofstream outfile( output_name.c_str() );
  outfile << "# .PCD v0.7 - Point Cloud Data file format"
    "\nVERSION 0.7"
    "\nFIELDS x y z\n";
  outfile << "SIZE 4 4 4\n"
    "TYPE F F F\n"
    "COUNT 1 1 1\n"
    "WIDTH " << count << "\n"
    "HEIGHT 1 \n"
    "VIEWPOINT " << std::setprecision(20)
          << mean_center.x() << " " << mean_center.y() << " "
          << mean_center.z() << " 1 0 0 0\n"
    "POINTS " << count << "\n"
    "DATA binary\n";

  // Write out the floats
  {
    TerminalProgressCallback tpc("","");
    double inc_amount = 1.0 / double(point_cloud.rows() );
    tpc.report_progress(0);

    for (size_t j = 0; j < point_cloud.rows(); j++ ) {
      for ( size_t i = 0; i < point_cloud.cols(); i++ ) {
        Vector3 copy = subvector(point_cloud(i,j),0,3);
        if ( copy != Vector3() ) {
          Vector3f copyf = copy - mean_center; // Subtract in double .. then cast to float.
          outfile.write(reinterpret_cast<char*>(&copyf[0]), 12);
        }
      }
      tpc.report_incremental_progress( inc_amount );

    }
    tpc.report_finished();
  }

  outfile.close();

  return 0;
}
