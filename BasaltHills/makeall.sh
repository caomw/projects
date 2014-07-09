#!/bin/bash

make_tool.sh convert_dem_to_pcd
#opts="-I$HOME/projects/packages/include/ -I$HOME/projects/packages/include/pcl-1.6 -I$HOME/projects/base_system/include/boost-1_53/ -L$HOME/projects/packages/lib -lpcl_common -lpcl_features -lpcl_filters -lpcl_geometry -lpcl_io -lpcl_io_ply -lpcl_kdtree -lpcl_octree -lpcl_registration -lpcl_sample_consensus -lpcl_search -lpcl_segmentation -L$HOME/projects/base_system/lib -lboost_filesystem-mt-1_53 -lboost_system-mt-1_53"
opts2="-I$HOME/projects/packages/pcl1.7/include/pcl-1.7 -I$HOME/projects/packages/include/ -I$HOME/projects/base_system/include/boost-1_53/ -L$HOME/projects/packages/pcl1.7/lib -lpcl_common -lpcl_features -lpcl_filters -lpcl_io -lpcl_io_ply -lpcl_kdtree -lpcl_octree -lpcl_registration -lpcl_sample_consensus -lpcl_search -lpcl_segmentation -L$HOME/projects/base_system/lib -lboost_filesystem-mt-1_53 -lboost_system-mt-1_53"

g++ -o pcl_random_subsample $opts pcl_random_subsample.cc
g++ -o pcl_icp_align $opts pcl_icp_align.cc
g++ -o pcl_icp_align2 $opts2 pcl_icp_align2.cc

export LD_LIBRARY_PATH=$HOME/projects/packages/lib:$HOME/projects/base_system/lib
