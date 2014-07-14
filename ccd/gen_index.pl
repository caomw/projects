#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use File::Basename;
use Cwd;

MAIN:{

  # Generate a list of all pairs in the given set of directories,
  # together with tdi and scan direction.
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 dir\n";
    exit(0);
  }

  my @dirs = @ARGV;
  my $currDir = getcwd;
  foreach my $dir (@dirs){

    chdir $currDir;
    chdir $dir;
    my $execDir = dirname(__FILE__);
    my $ans = qx($execDir/print_files.pl);
    $ans =~ s/\s*$//g;
    my @files = split(/\s+/, $ans);
    my $line = $dir;
    
    foreach my $file (@files){
      $file = $file . ".xml";
      next unless (-f $file);
      
      open(FILE, "<$file");
      my $text = join("", <FILE>);
      close(FILE);
      my $tdi = -1;
      if ($text =~ /\<TDILEVEL\>(\d+)\<\/TDILEVEL\>/s){
        $tdi = $1;
      }
    my $scandir = "";
      if ($text =~ /\<SCANDIRECTION\>(\w+)\<\/SCANDIRECTION\>/s){
        $scandir = $1;
      }
      $line = "$line $file $tdi $scandir ";
      
    }
    $line =~ s/\s*$//g;
    print "$line\n";
  }
  
}
