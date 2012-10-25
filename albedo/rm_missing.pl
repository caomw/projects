#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  if ( scalar(@ARGV) < 2 ){ 
     print "Error: Need to specify the DIM and DEM directories\n";
  }

  #my $dimDir = "/byss/moon/apollo_metric/apollo_15_16_17/DIM_input_1024ppd";
  #my $demDir = "/byss/moon/apollo_metric/apollo_15_16_17/DEM_input";
  my $dimDir = $ARGV[0];
  my $demDir = $ARGV[1];
  my %dimFiles = parse(qx(ls $dimDir));
  my %demFiles = parse(qx(ls $demDir));
  open(FILE, "<cubes/sunpos.txt");        my %sunPos = parse(<FILE>); close(FILE);
  open(FILE, "<cubes/spacecraftpos.txt"); my %spcPos = parse(<FILE>); close(FILE);
  
  my $count = 0;
  my ($dimOut, $demOut, $sunOut, $spcOut) = ("", "", "", "");
  foreach my $key ( sort {$a cmp $b} keys %dimFiles){
    if ( !exists $demFiles{$key} || !exists $sunPos{$key} || !exists $spcPos{$key} ){
      print "skipping key: $key\n";
      next;
    }
    $count++;
    $dimOut .= $dimFiles {$key} . "\n";
    $demOut .= $demFiles {$key} . "\n";
    $sunOut .= $sunPos   {$key} . "\n";
    $spcOut .= $spcPos   {$key} . "\n";
  }
  open(FILE, ">sunpos.txt_new");        print FILE $sunOut; close(FILE);
  open(FILE, ">spacecraftpos.txt_new"); print FILE $spcOut; close(FILE);

  foreach my $key ( sort {$a cmp $b} keys %dimFiles){
    if ( !exists $demFiles{$key} || !exists $sunPos{$key} || !exists $spcPos{$key} ){
      print "rm -fv $dimDir/$dimFiles{$key}\n";
    }
  }
  foreach my $key ( sort {$a cmp $b} keys %demFiles){
    if ( !exists $dimFiles{$key} || !exists $sunPos{$key} || !exists $spcPos{$key} ){
      print "rm -fv $demDir/$demFiles{$key}\n";
    }
  }
  
  print "Number of kept items: $count\n";
  print "Don't forget to overwrite the sun and spaceraft files!\n"; 
}

sub parse{
  
  my %hash;
  foreach my $line (@_){
    $line =~ s/\n//g;
    next unless ($line =~ /(AS1\d-M-\d+)/);
    $hash{$1} = $line;
    #print "--$1--$line--\n";
  }

  return %hash;
}
