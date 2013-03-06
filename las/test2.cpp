#include <iostream>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
#endif

#include "lasreader.hpp"
#include "laswriter.hpp"

void byebye(int a = 0, int b = 0){
  std::cerr << "Got an error" << std::endl;
  exit(0);
}

int main(int argc, char *argv[])
{
  int i;
  bool verbose = false;
  bool projection_was_set = false;
  bool quiet = false;
  int file_creation_day = -1;
  int file_creation_year = -1;
  int set_version_major = -1;
  int set_version_minor = -1;
  int set_classification = -1;
  char* set_system_identifier = 0;
  char* set_generating_software = 0;
  double start_time = 0.0;

  LASreadOpener lasreadopener;
  LASwriteOpener laswriteopener;

  if (!lasreadopener.parse(argc, argv)) byebye(true);
  if (!laswriteopener.parse(argc, argv)) byebye(true);

  for (i = 1; i < argc; i++)
    {
      if (argv[i][0] == '\0')
        {
          continue;
        }
      else if (strcmp(argv[i],"-set_offset") == 0)
        {
          if ((i+3) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs 3 arguments: x y z\n", argv[i]);
            }
          F64 offset[3];
          i++;
          sscanf(argv[i], "%lf", &(offset[0]));
          i++;
          sscanf(argv[i], "%lf", &(offset[1]));
          i++;
          sscanf(argv[i], "%lf", &(offset[2]));
          lasreadopener.set_offset(offset);
        }
      else if (strcmp(argv[i],"-add_extra") == 0)
        {
          if ((i+3) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs at least 3 arguments: data_type name description\n", argv[i]);
            }
          if (((i+4) < argc) && (atof(argv[i+4]) != 0.0))
            {
              if (((i+5) < argc) && (atof(argv[i+5]) != 0.0))
                {
                  lasreadopener.add_extra_attribute(atoi(argv[i+1]), argv[i+2], argv[i+3], atof(argv[i+4]), atof(argv[i+5]));
                  i+=5;
                }
              else
                {
                  lasreadopener.add_extra_attribute(atoi(argv[i+1]), argv[i+2], argv[i+3], atof(argv[i+4]));
                  i+=4;
                }
            }
          else
            {
              lasreadopener.add_extra_attribute(atoi(argv[i+1]), argv[i+2], argv[i+3]);
              i+=3;
            }
        }
      else if (strcmp(argv[i],"-set_creation_date") == 0 || strcmp(argv[i],"-set_file_creation") == 0)
        {
          if ((i+2) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs 2 arguments: day year\n", argv[i]);
            }
          i++;
          sscanf(argv[i], "%d", &file_creation_day);
          i++;
          sscanf(argv[i], "%d", &file_creation_year);
        }
      else if (strcmp(argv[i],"-set_class") == 0 || strcmp(argv[i],"-set_classification") == 0)
        {
          if ((i+1) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs 1 argument: value\n", argv[i]);
            }
          i++;
          set_classification = atoi(argv[i]);
        }
      else if (strcmp(argv[i],"-set_system_identifier") == 0)
        {
          if ((i+1) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs 1 argument: name\n", argv[i]);
            }
          i++;
          set_system_identifier = argv[i];
        }
      else if (strcmp(argv[i],"-set_generating_software") == 0)
        {
          if ((i+1) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs 1 argument: name\n", argv[i]);
            }
          i++;
          set_generating_software = argv[i];
        }
      else if (strcmp(argv[i],"-set_version") == 0)
        {
          if ((i+1) >= argc)
            {
              fprintf(stderr,"ERROR: '%s' needs 1 argument: major.minor\n", argv[i]);
            }
          i++;
          if (sscanf(argv[i],"%d.%d",&set_version_major,&set_version_minor) != 2)
            {
              fprintf(stderr, "ERROR: cannot understand argument '%s' of '%s'\n", argv[i], argv[i-1]);
            }
        }
      else if (argv[i][0] != '-')
        {
          lasreadopener.add_file_name(argv[i]);
        }
      else
        {
          fprintf(stderr, "ERROR: cannot understand argument '%s'\n", argv[i]);
        }
    }

  if (!lasreadopener.active())
    {
      fprintf(stderr, "ERROR: no input specified\n");
      byebye(true, argc==1);
    }

  // make sure that input and output are not *both* piped

  if (lasreadopener.piped() && laswriteopener.piped())
    {
      fprintf(stderr, "ERROR: input and output cannot both be pipes\n");
      byebye(true, argc==1);
    }

  while (lasreadopener.active())
    {
      // open lasreader

      LASreader* lasreader = lasreadopener.open();

      if (lasreader == 0)
        {
          fprintf(stderr, "ERROR: could not open lasreader\n");
          byebye(true, argc==1);
        }

      // open the output

      LASwriter* laswriter = laswriteopener.open(&lasreader->header);

      if (laswriter == 0)
        {
          fprintf(stderr, "ERROR: could not open laswriter\n");
          byebye(true, argc==1);
        }

      // loop over points

      while (lasreader->read_point())
        {
          // maybe set classification
          if (set_classification != -1)
            {
              lasreader->point.classification = set_classification;
            }
          // write the point
          LASpoint & point = lasreader->point;
          std::cout << "point is " << point.x << ' ' << point.y << ' ' << point.z << std::endl;
          laswriter->write_point(&lasreader->point);
        }
      lasreader->close();

      if (!laswriteopener.piped())
        {
          laswriter->update_header(&lasreader->header, FALSE, TRUE);
        }
      laswriter->close();

      delete laswriter;
      delete lasreader;

      laswriteopener.set_file_name(0);

    }

  byebye(false, argc==1);

  return 0;
}
