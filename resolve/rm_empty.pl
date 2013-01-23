#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 dir\n";
    exit(0);
  }

  my $dir = shift @ARGV;
  my ($file, @files);
  
  @files  = <$dir/LRONAC_DEM_*.tif>;
  foreach $file (@files){
    my ($DRG, $DEM, $DEMError, $hill) = ($file, $file, $file, $file);
    $DRG =~ s/DEM/DRG/g;
    $DEMError =~ s/DEM/DEMError/g; $DEMError =~ s/\.tif\s*$//g;
    $hill =~ s/DEM/hillshade/g;
    my $text = qx(gdalinfo -stats $file | grep Minimum | grep Maximum | head -n 1);
    #print "$text\n";
    if ($text !~ /Maximum/ || $text =~ /Maximum=0\.?0*?,/){

      my $trash = "$dir/trash";
      mkdir $trash;

      print "\n$file $DEM $DEMError $hill $text\n";
      print qx (mv -fv $DRG       $trash) . "\n";
      print qx (mv -fv $DEM       $trash) . "\n";
      print qx (mv -fv $DEMError* $trash) . "\n";
      #print qx (mv -fv $hill      $trash) . "\n";
    }
  }

}
