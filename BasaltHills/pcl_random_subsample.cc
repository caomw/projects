#include <iostream>
#include <pcl/point_types.h>
#include <pcl/filters/passthrough.h>
#include <pcl/io/pcd_io.h>
#include <pcl/filters/random_sample.h>
#include <pcl/filters/voxel_grid.h>
#include <time.h>

int main (int argc, char** argv)
{

  std::cout << "\n\n"; for (int s = 0; s < argc; s++) std::cout << argv[s]  << ' '; std::cout << "\n\n";
  
  //srand( time(NULL) );
  
  if (argc < 4){
    std::cerr << "Usage: " << argv[0] << " input.pcd output.pcd goalInMeters" << std::endl;
    exit(0);
  }
  
  std::string input_name( argv[1] ), output_name( argv[2] ), number_str( argv[3] );
  std::istringstream iss( number_str );
  float goal_meters;
  iss >> goal_meters;
  
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud (new pcl::PointCloud<pcl::PointXYZ>);
  pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_filtered (new pcl::PointCloud<pcl::PointXYZ>);

  if (pcl::io::loadPCDFile<pcl::PointXYZ> (input_name, *cloud) == -1) //* load the file
    {
      std::string errStr = "Couldn't read file " + input_name + "\n";
      PCL_ERROR (errStr.c_str());
      return (-1);
    }

  // Create the filtering object
  // pcl::RandomSample<pcl::PointXYZ> random_sample;
  // random_sample.setInputCloud(cloud);
  // random_sample.setSample( goal_samples );
  // random_sample.setSeed(rand());
  // random_sample.filter(*cloud_filtered);

  // Downsample with voxel
  pcl::VoxelGrid<pcl::PointXYZ> sor;
  sor.setInputCloud(cloud);
  sor.setLeafSize(goal_meters,goal_meters,goal_meters);
  sor.filter(*cloud_filtered);

  std::cout << "Output size: " << cloud_filtered->width * cloud_filtered->height << std::endl;

  // Write the result
  std::cout << "Will write: " << output_name << std::endl;
  pcl::io::savePCDFile<pcl::PointXYZ>(output_name.c_str(), *cloud_filtered,true);

  return (0);
}
