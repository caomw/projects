#include <iostream>
#include "lasreader.hpp"
#include "laswriter.hpp"
using namespace std;
int main(int argc, char *argv[])
{

//   LASreadOpener lasreadopener;
//   char file_name[] = "tmp.txt";
  
//   lasreadopener.set_file_name(file_name);
//   LASreader* lasreader = lasreadopener.open();

//   if (lasreader == 0){
//     fprintf(stderr, "ERROR: could not open lasreader\n");
//     exit(1);
//   }
//   std::cout << "reader is " << lasreader << std::endl;

//   LASreader lasreader2;

  LASheader las_header;

  int N = 10;
  las_header.number_of_point_records = N;
  
  LASwriteOpener laswriteopener;
  laswriteopener.set_file_name("test2.las");
  LASwriter* laswriter = laswriteopener.open(&las_header);
  LASpoint point;
  for (int s = 0; s < las_header.number_of_point_records; s++){
//     point.x = s;
//     point.y = s + 1;
//     point.z = s + 2;
    laswriter->write_point(&point);
  }
  laswriter->close();
  delete laswriter;
  
  return 0;

  {  
    LASreadOpener lasreadopener;
    lasreadopener.set_file_name("original.laz");
    LASreader* lasreader = lasreadopener.open();

    LASwriteOpener laswriteopener;

    std::cout << "buffer size is " << lasreadopener.get_buffer_size() << std::endl;
    std::cout << "number of point records is: " << (lasreader->header).number_of_point_records << std::endl;
    laswriteopener.set_file_name("created.las");
    LASwriter* laswriter = laswriteopener.open(&lasreader->header);

    int count = 0;
    while (lasreader->read_point()){
      LASpoint & point = lasreader->point;
      count++;
      //std::cout << "point is " << count << ' ' << point.x << ' ' << point.y << ' ' << point.z << std::endl;
      laswriter->write_point(&lasreader->point);
    }

    laswriter->close();
    delete laswriter;

    lasreader->close();
    delete lasreader;
  }
  return 0;
}
