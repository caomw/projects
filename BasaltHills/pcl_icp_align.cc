#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>

#include <pcl/registration/icp.h>

#include <boost/thread/thread.hpp>
#include <Eigen/Dense>

int
main (int argc, char** argv)
{

  std::cout << "\n\n"; for (int s = 0; s < argc; s++) std::cout << argv[s]  << ' '; std::cout << "\n\n";
  
  std::string input1( argv[1] ), input2( argv[2] );

  // Loading first scan of room.
  pcl::PointCloud<pcl::PointXYZ>::Ptr target_cloud (new pcl::PointCloud<pcl::PointXYZ>);
  if (pcl::io::loadPCDFile<pcl::PointXYZ> (input1, *target_cloud) == -1)
    {
      PCL_ERROR ("Couldn't read file room_scan1.pcd \n");
      return (-1);
    }
  std::cout << "Loaded " << target_cloud->size () << " data points from room_scan1.pcd" << std::endl;

  // Loading second scan of room from new perspective.
  pcl::PointCloud<pcl::PointXYZ>::Ptr input_cloud (new pcl::PointCloud<pcl::PointXYZ>);
  if (pcl::io::loadPCDFile<pcl::PointXYZ> (input2, *input_cloud) == -1)
    {
      PCL_ERROR ("Couldn't read file room_scan2.pcd \n");
      return (-1);
    }
  std::cout << "Loaded " << input_cloud->size () << " data points from room_scan2.pcd" << std::endl;

  pcl::IterativeClosestPoint<pcl::PointXYZ, pcl::PointXYZ> icp;
  icp.setInputCloud(input_cloud);
  icp.setInputTarget(target_cloud);
  pcl::PointCloud<pcl::PointXYZ> Final;
  icp.setMaxCorrespondenceDistance( 100 );
  icp.setMaximumIterations( 200 );
  icp.setRANSACOutlierRejectionThreshold( 100 );
  std::cout << "Ransac Threshold: " << icp.getRANSACOutlierRejectionThreshold() << std::endl;
  std::cout << "TransformationEpsilon: " << icp.getTransformationEpsilon() << std::endl;
  icp.setEuclideanFitnessEpsilon(0);
  Eigen::Matrix<float,4,4> previous_solution; // I got this from running blind once before. I'm using this to tighten my tolerances.
  previous_solution <<
    1,  0., 0.,    0.118664,
    0., 1., 0.,   -18.4589,
    0., 0., 1.,    35.095,
    0., 0., 0.,    1.;
  icp.align(Final, previous_solution);
  std::cout << "has converged:" << icp.hasConverged() << " score: " <<
    icp.getFitnessScore() << std::endl;
  std::cout << icp.getFinalTransformation() << std::endl;

  // Saving transformed input cloud.
  pcl::io::savePCDFileBinary ("target_transformed.pcd", Final);

  return (0);
}
