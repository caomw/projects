#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
undef $/;          # read one whole file in one scalar
require 'make_kml_utils.pl';

MAIN:{

  # Work around the inability of image2qtree to handle a big set of images.
  # Break a given set into several subsets, generate kml directories for all
  # of them, and generate a master kml file which will call those directories.
     
  if (scalar(@ARGV) < 1){
    print "Usage: $0 dirName\n";
    exit(0);
  }

  my $dir = $ARGV[0];
  if (! -d $dir){
    print "Directory $dir does not exist.\n";
  }
 
  my $base = "/byss/docroot/oleg/$dir";
  mkdir $base;

  my $maxNum = 1000;
  my @all_files = <$dir/albedo/*DRG*.tif>;
  my ($start, $end);
  if (scalar (@all_files) > $maxNum){
    # Need to split the albedo into several chunks due to a bug in image2qtree
    $start = 15; $end = 17;
  }else{
    $start = 0;
    $end   = 0;
  }

  my @resDirs;
  for (my $p = $start; $p <= $end; $p++){
   
    my $prefix;
    if ($start == $end){
      $prefix = "";
    }else{
      $prefix = "AS$p";
    }

    my @files = <$dir/albedo/$prefix*DRG*.tif>;
    my $num = scalar(@files);
    #print "Number of files is $num\n";
  
    my $count = -1; 
    while (scalar(@files) > 0){
      $count++;
      my @sub = splice @files, 0, $maxNum;
      print "Splicing " . scalar(@sub) . "\n";
      print "Left " . scalar(@files) . "\n";
      my $list = join(" ", @sub);
      
      my ($name, $resDir);
      if ($prefix ne ""){
        $name = $prefix . "_" . $count;
      }else{
        $name = "all";
      }
      $resDir = "$base/" . $name;
      
      my $cmd = "~/visionworkbench/src/vw/tools/image2qtree -m kml "
         ."-o $resDir $list";
      print "$cmd\n";
      print qx($cmd) . "\n";

      my $kml_file = "$resDir/$name.kml";
      open(FILE, "<$kml_file");
      my $text = join("", <FILE>);
      print "File is $kml_file\n";

      $text =~ s!(\<kml)\s+(xmlns)!$1 . " hint=\"target=moon\" " . $2!e; 
      $text =~ s!\>([^\<\>]*?\.(?:kml|png))!>https://byss.arc.nasa.gov/oleg/$dir/$name/$1!g;
      open(FILE, ">$kml_file");
      print FILE "$text\n";
      close(FILE);

      # Rename the index to reflect the directory it is in (helps distinguishing things in Google Earth)
      my $name2 = $base . "_" . $name;
      $name2 =~ s/^.*\///g;
      print qx(mv -fv $resDir/$name.kml $resDir/$name2.kml);
      
      $resDir =~ s!^.*?oleg!https://byss.arc.nasa.gov/oleg!g;
      $resDir .= "/$name2.kml";
      push (@resDirs, $resDir);
      
    }
  }

  if ($start != $end){
    # If there are multiple kml directories, create a master index
    # file pointing to the index of each of them, so that at the end
    # we have just one url.
    my $index = "$base/$dir.kml";
    create_combined_kml($index, \@resDirs);
    my $index_url = "https://byss.arc.nasa.gov/oleg/$dir/$dir.kml";
    @resDirs = ($index_url);
  }
  
  foreach my $resDir (@resDirs){
    print " || $resDir\n";
  }
  
}

