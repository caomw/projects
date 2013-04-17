#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Cwd;
undef $/;          # read one whole file in one scalar

# Run one test. See the script run_tests for more info.

MAIN:{

  if (scalar(@ARGV) < 4){
    print "Usage: $0 -baseDir <baseDir> -runDir <runDir>\n";
    exit(1);
  }

  my $baseDir    = $ARGV[1]; # Here will save the status of each test and the summary
  my $runDir     = $ARGV[3]; # Here will run the curent test

  set_bin_path();

  my $exitStatus =  get_failed_status(); # Start as failed
  my $runTime    = -1;

  if ( -d $baseDir){
    chdir $baseDir;
  }else{
    print "ERROR: $baseDir does not exist\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  set_status( $baseDir, $runDir, get_running_flag(), $exitStatus, $runTime );  # running

  if ( -d $runDir){
    chdir $runDir;
  }else{
    print "ERROR: Directory $runDir does not exist\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  if ( ! -e "../bin/validate.sh"){
    print "ERROR: File ../bin/validate.sh does not exist\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  if (! -x "../bin/validate.sh"){
    print "ERROR: File ../bin/validate.sh is not executable\n";
    set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );
    exit(1);
  }

  my $prog = 'source ~/.bashenv; /usr/bin/time -f "elapsedTime=%E mem=%M" ./run.sh';
  my $outfile = "output.txt";

  # Do the run. Extract the exist status and the running time.
  qx(uname -a           >  $outfile 2>&1);
  qx(rm -rfv ./run      >> $outfile 2>&1);
  qx($prog              >> $outfile 2>&1);
  qx(../bin/validate.sh >> $outfile 2>&1);
  $exitStatus = ($? >> 8);
  print "exit status is: $exitStatus\n";
  if (!-e $outfile){
    $exitStatus = get_failed_status();
  }else{
    open(OFILE, "<$outfile"); my $data = <OFILE>; close(OFILE);
    if ($data =~ /^.*elapsedTime=(.*?) mem=/s){
      $runTime = $1;
    }
  }

  set_status( $baseDir, $runDir, get_done_flag(), $exitStatus, $runTime );      # done
}

sub set_bin_path{

  # Get this script's dependencies from the directory where the script is located

  my $binPath = $0;
  $binPath =~ s!^(.*)/.*$!$1!g;

  push(@INC, $binPath);
  require 'test_utils.pl';

  return $binPath;
}
