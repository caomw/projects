#!/usr/bin/perl
use strict;                   # insist that all variables be declared
use diagnostics;              # expand the cryptic warnings
undef $/;                     # read one whole file in one scalar
require 'make_kml_utils.pl';
use File::Path;

MAIN:{

  # Work around the inability of image2qtree to handle a big set of images.
  # Break a given set into several subsets, generate kml directories for all
  # of them, and generate a master kml file which will call those directories.

  my ($inputDir, $outputDir);
  
  if (scalar(@ARGV) < 1) {
    print "Usage: $0 dirName\n";
    exit(0);
  }

  $inputDir = $ARGV[0];
  if (! -d $inputDir) {
    print "Directory $inputDir does not exist.\n";
  }
  if ( -d "$inputDir/albedo"){
    $inputDir = "$inputDir/albedo";
  }
  
  # If an output dir is specified, use it instead of the input dir.
  if (scalar(@ARGV) > 1) {
    $outputDir = $ARGV[1];
  }else{
    $outputDir = $inputDir;
    # make albedo_3/albedo into albedo_3 and albedo_3/error into error_3
    if ($outputDir =~ /(.*?)albedo(_[^\/]+)\/(\w+)$/){
      $outputDir = $1 . $3 . $2;
    }
  }
  $outputDir =~ s/^\.\///g; # rm the leading dot
  $outputDir =~ s/\./p/g;   # rm the other dots as they confuse the kml generator
  $outputDir =~ s/\//_/g;
  print "outputDir is $outputDir\n";
  
  my $base = "/byss/docroot/oleg";
  if (! -d $base){
    $base = "$outputDir/kml";
    mkpath($base);
  }

  my $beg = 0;
  my $end = 4;

  my @urls;
  for (my $p = $beg; $p < $end; $p++) {
    
    my (@files, $name, $resDir);

    # Put the files into groups, and create a kml directory
    # and index for each of them.
    
    $name = "p$p";
    $resDir= "$outputDir/$name";      
    if ($p == 0){
      @files = <$inputDir/tile*E*N.tif>;
    } elsif ($p == 1){
      @files = <$inputDir/tile*E*S.tif>;
    }elsif ($p == 2) {
      @files = <$inputDir/tile*W*N.tif>;
    } elsif ($p == 3){
      @files = <$inputDir/tile*W*S.tif>;
    }
    next unless (scalar(@files) > 0);
    
    # Create a single virtual tif out of all the individual tifs, otherwise
    # they are too many and image2qtree chokes.
    my $list = join(" ", @files);
    mkpath("$base/$outputDir");
    my $vrt = "$base/$outputDir/vrt$p.tif";
    my $cmd = "gdalbuildvrt $vrt $list";
    print "$cmd\n";
    print qx($cmd) . "\n";
    $list = $vrt;
    
    $cmd = "~/projects/visionworkbench/src/vw/tools/image2qtree -m kml "
       ."-o $base/$resDir $list >/dev/null &";
    print "$cmd\n";
    #print qx($cmd) . "\n";
    system($cmd); # execute in the background

    # The url to the current kml
    my $url = "https://byss.arc.nasa.gov/oleg/$resDir";
    $url .= "/$name.kml";
    push (@urls, $url);

    # Make the links absolute. To do: This part may no longer be necessary.
    # But then need to adjust the text above.
    my $kml_file = "$base/$resDir/$name.kml";
    next unless (-e $kml_file);
    open(FILE, "<$kml_file") || die "Cannot open $kml_file\n";
    my $text = join("", <FILE>);
    $text =~ s!(\<kml)\s+(xmlns)!$1 . " hint=\"target=moon\" " . $2!e; 
    $text =~ s!\>([^\<\>]*?\.(?:kml|png))!>https://byss.arc.nasa.gov/oleg/$resDir/$1!g;
    open(FILE, ">$kml_file");
    print FILE "$text\n";
    close(FILE);
  }
  
  # Create a master kml index which will point to the individual kml
  # indices created earlier, so that at the end we have just one url.

  mkpath("$base/$outputDir");
  my $index = "$base/$outputDir/$outputDir.kml";
  create_combined_kml($index, \@urls);
  my $index_url = "https://byss.arc.nasa.gov/oleg/$outputDir/$outputDir.kml";
  
  print "\n$index_url\n\n";
}

