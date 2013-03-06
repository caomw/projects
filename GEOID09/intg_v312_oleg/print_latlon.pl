#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use List::Util qw(min max);
MAIN:{

#   if ( scalar(@ARGV) < 1 ){
#     print "Usage: $0 name files.tif\n";
#     exit(1);
#   }

  # The box containing continental US and Alaska
  #my $beg_lon = 172; my $end_lon = 300; my $beg_lat = 24; my $end_lat = 72;
 
  # The box containing Hawaii
  #my $beg_lon = 190; my $end_lon = 210; my $beg_lat = 15; my $end_lat = 30;
  #18 - 24 N & 199 - 206 E

  # Guam
  #my $beg_lon = 140; my $end_lon = 150; my $beg_lat = 10; my $end_lat = 20;
  #11 - 18 N & 143 - 146 E

  #  Puerto Rico
  #my $beg_lon = 280; my $end_lon = 300; my $beg_lat = 10; my $end_lat = 30;
  #21 - 15 N & 291 - 296 E

  #  Samoa
  my $beg_lon = 180; my $end_lon = 200; my $beg_lat = -20; my $end_lat = -10;
  #17 - 11 S & 168 - 174 W

  my $spacing = 5; # spacing in minutes
  my $numMinutes = 60; # number of minutes in on edgree
  open(FILE, ">latlon.txt");
  my $n = 0;
  for (my $lon = $beg_lon; $lon <= $end_lon; $lon++){
    
    for (my $lon_minute = 0; $lon_minute < $numMinutes; $lon_minute += $spacing){
      
      for (my $lat = $beg_lat; $lat <= $end_lat; $lat++){
        
        for (my $lat_minute = 0; $lat_minute < $numMinutes; $lat_minute += $spacing){

          my $lon_val = $lon + $lon_minute/$numMinutes;
          my $lat_val = $lat + $lat_minute/$numMinutes;

          next if ($lon_val > $end_lon);
          next if ($lat_val > $end_lat);
          
          print FILE "$lat_val $lon_val\r\n";
          
          $n++; #if ($n == 3){ exit(0); }
          
        }
      }
    }
  }
  
  close(FILE);

  print "Number of points is $n\n";
  my $lon_len  = ($end_lon - $beg_lon)*$numMinutes/$spacing + 1;
  my $lat_len  = ($end_lat - $beg_lat)*$numMinutes/$spacing + 1;

  print "Lon points: $lon_len\n";
  print "Lat points: $lat_len\n";
  
  my $expected = $lon_len*$lat_len;
  if ($n != $expected){
    print "ERROR: Expected $expected points, but got $n points.\n";
    exit(1);
  }else {
    print "Success!\n";
  }
  
}
