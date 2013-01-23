#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 file.tif\n";
    exit(1);
  }

  my $file = shift @ARGV;
  if ( ! -e $file){
    print "ERROR: File $file does not exist\n";
    exit(1);
  }

  my $text = qx(gdalinfo $file | grep "Upper Left");
  my ($lon, $lat);
  if ($text =~ /^.*?\(.*?\).*?\(\s*(.*?)\s*,\s*(.*?)\s*\)/){
    $lon = $1;
    $lat = $2;
  }else{
    print "ERROR: Can't match lon and lat\n"; 
  }

  my $str = clean_val($lon, 1) . "_" . clean_val($lat, 0);

  my $dir = "";
  if ($file =~ /^\s*(.*?)\//){
    $dir = $1;
  }
  
  if ($file =~ /hill/){
    $str = "hillshade_$str.tif";
  }elsif ($file =~ /DEMError/){
    $str = "DEMError_$str.tif";
  }elsif ($file =~ /DEM/){
    $str = "DEM_$str.tif";
  }elsif ($file =~ /DRG/){
    $str = "DRG_$str.tif";
  }

  $str = $dir . "/LRONAC_" . $str;
  print "$file $str\n";
  print "mv -fv $file $str\n";
  print qx(mv -fv $file $str) . "\n";
}

sub clean_val{
  my $data = shift;
  my $is_lon = shift;

  my ($deg, $min, $sec, $pos);
  if ($data =~ /^(.*?)d(.*?)\'(.*?)\"(\w+)/){
    ($deg, $min, $sec, $pos) = ($1, $2, $3, $4);
  }else{
    print "ERROR: Could not parse: $data\n";
    exit(1);
  }

  if ($is_lon){ $deg = sprintf("%03d", $deg); }
  else        { $deg = sprintf("%02d", $deg); }

  $min = sprintf("%02d", $min);
  return "$deg" . "deg" . "$min" . "min" . "$pos";
  
}
