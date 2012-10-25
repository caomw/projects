#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  # Decide whether the current image will be run on the current machine or not.
  # Each image will be run on exactly one machine.

  shift @ARGV;

  my %machines = ("byss" => 0, "lunokhod1" => 1, "lunokhod2" => 2, "alderaan" => 3);
  my $numMachines = scalar(keys %machines);
  my $currMachine = qx(uname -n); $currMachine =~ s/\s*$//g;
  $currMachine =~ s/\..*?$//g;
  if (!exists $machines{$currMachine}){
    print "Error: Running on the wrong machine!";
    exit(1);
  }
  my $currIndex = $machines{$currMachine};
  print "Num machines: $numMachines, currIndex=$currIndex, currMachine=$currMachine\n";

  my $cmd = join(" ", @ARGV);
  print "$cmd\n";

  my $currImage;
  if ( $cmd !~ /-i\s+([^\s]+)/){
    print "Error: cannot find the current image in $cmd\n";
    exit(1);
  }
  $currImage = $1;
  print "currImage is $currImage\n";

  my $imagesList;
  if ( $cmd !~ /-f\s+([^\s]+)/){
    print "Error: cannot find the list of images in $cmd\n";
    exit(1);
  }
  $imagesList = $1;
  print "imagesList is $imagesList\n";

  # Find the index of the current machine. If its remainder equals
  # to the current index, run it on the current machine.
  my $success    = 0;
  my $imageIndex = -1; # Will become 0 at first iteration
  open(FILE, "<$imagesList") || die "Cannot open $imagesList";
  foreach my $line (<FILE>){
    
    next unless ($line =~ /^\d+\s+([^\s]+)/);
    my $img = $1;
    $imageIndex++;

    next unless ($img eq $currImage);
    $success = 1;

    if ( $currIndex != $imageIndex % $numMachines ){
      print "Will skip image $currImage on this machine!\n";
      exit(0);
    }else{
      print "Will NOT skip image $currImage on this machine!\n";
      print "jobID=$imageIndex\n";
    } 
  }
  
  if ( !$success ){
    print "Could not locate image: $currImage in $imagesList\n";
    exit(1);
  }

  # Execute the command for the current image
  system($cmd);
}

