#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Math::Trig;
MAIN:{

  if (scalar(@ARGV) < 1){
    print "Usage: $0 file.tif\n";
    exit(0);
  }
  my $file = $ARGV[0];

  my ($name, $lfile, $lines, $samples, $offset, $out, $txt, $pix_size, $map_res);
  my $pi = pi;
  my $R = 1737.4;

  $lfile = $file;
  $lfile =~ s/^.*\/(.*?)$/$1/g;
  $name  = $lfile;
  $name  =~ s/\.tif//g;

  print "Name is $name\n";

  my $base = $ENV{'HOME'} . "/projects/albedo";
  $ENV{'LD_LIBRARY_PATH'} = $base . '/tiff-4.0.3/libtiff/.libs/';
  $out = qx($base/tif_offset $file 2>/dev/null);
  if ($out =~ /strip:\s*(\d+)/){
    $offset = $1;
    print "Offset is $offset\n";
  }else{
    print "Could not parse the offset from: $out for file: $file\n";
    exit(1);
  }

  $txt = join ("", qx(gdalinfo $file));

  if ($txt =~ /Size is\s*(\d+),\s*(\d+)/){
    $samples = $1;
    $lines = $2;
  }else{
    print "Could not parse the size from: $out\n";
    exit(1);
  }
  print "samples and lines is $samples $lines\n";

  if ($txt =~ /Pixel Size\s*=\s*\(\s*(.*?),/){
    $pix_size = $1;
    $map_res = 1.0/$pix_size;
  }else{
    print "Could not parse the pixel size from: $out\n";
    exit(1);
  }
  print "Map res is $map_res\n";

  my ($min_lon, $min_lat);
  if ($txt =~ /Lower Left\s*\(\s*(.*?)\s*,\s*(.*?)\)/){
    $min_lon = $1;
    $min_lat = $2;
  }
  print "Min lon and lat are $min_lon $min_lat\n";

  my ($max_lon, $max_lat);
  if ($txt =~ /Upper Right\s*\(\s*(.*?)\s*,\s*(.*?)\)/){
    $max_lon = $1;
    $max_lat = $2;
  }
  print "Max lon and lat are $max_lon $max_lat\n";

  my $map_scale = $pix_size*2.0*$pi*$R/360;
  # Remove spurrious error
  my $big = 1.0e+14;
  $map_scale = int($map_scale * $big + 0.5)/$big;

  print "map scale is $map_scale\n";

  my $descr = "Albedo";
  $descr = "Error"  if ($lfile =~ /E\.tif/);
  $descr = "Mask"   if ($lfile =~ /M\.tif/);
  $descr = "Georeferenced Tile of $descr Mosaic.";

  open(FILE, "<$base/reference.lbl");
  my @lines = <FILE>;
  close(FILE);

  my $lbl_file = $file;
  $lbl_file =~ s/\.tif/.lbl/g;
  open(FILE, ">$lbl_file");
  print "Writing: $lbl_file\n";

  # Note: We assume that center lon and lat are zero.

  # The formulas below give the same values.
  my $line_offset =  $max_lat * $map_res;
  my $samp_offset = -$min_lon * $map_res;
  #print "--- old values: $line_offset $samp_offset\n";
  $line_offset =  $max_lat * $R * $pi / $map_scale / 180.0;
  $samp_offset = -$min_lon * $R * $pi / $map_scale / 180.0;
  print "Line and sample offset: $line_offset $samp_offset\n";

  my $is_comment = 0;

  foreach my $line (@lines){
    if ($line =~ /\/\*/) { $is_comment = 1; }

    if (!$is_comment){
      $line =~ s/\".*?\.tif/\"$lfile/g;
      $line =~ s/(PRODUCT_ID.*?\").*?$/$1$name\"/g;
      $line =~ s/(LINES\s*=\s*)\d+/$1$lines/g;
      $line =~ s/(RECORD_BYTES\s*=\s*)\d+/$1$samples/g;
      $line =~ s/(LINE_LAST_PIXEL\s*=\s*)\d+/$1$lines/g;
      $line =~ s/(FILE_RECORDS\s*=\s*)\d+/$1$samples/g;
      $line =~ s/(LINE_SAMPLES\s*=\s*)\d+/$1$samples/g;
      $line =~ s/(SAMPLE_LAST_PIXEL\s*=\s*)\d+/$1$samples/g;
      $line =~ s/\d+(\s+\<BYTES>)/$offset$1/g;
      $line =~ s/(MAP_RESOLUTION\s*=\s*).*?(\s*\<PIX)/$1$map_res$2/g;
      $line =~ s/(MAP_SCALE\s*=\s*).*?(\s*\<KM)/$1$map_scale$2/g;
      $line =~ s/(MINIMUM_LATITUDE\s*=\s*).*?(\s*\<DEG)/$1$min_lat$2/g;
      $line =~ s/(MAXIMUM_LATITUDE\s*=\s*).*?(\s*\<DEG)/$1$max_lat$2/g;
      $line =~ s/(WESTERNMOST_LONGITUDE\s*=\s*).*?(\s*\<DEG)/$1$min_lon$2/g;
      $line =~ s/(EASTERNMOST_LONGITUDE\s*=\s*).*?(\s*\<DEG)/$1$max_lon$2/g;
      $line =~ s/(LINE_PROJECTION_OFFSET\s*=\s*).*?$/$1$line_offset/g;
      $line =~ s/(SAMPLE_PROJECTION_OFFSET\s*=\s*).*?$/$1$samp_offset/g;
      $line =~ s/(DESCRIPTION.*?\").*?(\")/$1$descr$2/g;
    }

    # This must be the last step
    $line = enforce_line_length($line);

    if ($line =~ /\*\//) { $is_comment = 0; }
    print FILE "$line";
  }

  close(FILE);
}

sub enforce_line_length{

  my $len = 78;
  my $line = shift;

  $line =~ s/[\r\n]//g;
  $line .= ' ' x $len;
  # We use \r\n as end-of-line as described in the documentation
  return ( substr $line, 0, $len ) . "\r\n";

}
