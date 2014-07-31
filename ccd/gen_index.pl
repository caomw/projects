#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use File::Basename;
use File::Spec;
use Cwd;

MAIN:{

  # Generate a list of all pairs in the given set of directories,
  # together with tdi and scan direction.
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 dirs\n";
    exit(0);
  }

  my $execDir = File::Spec->rel2abs(dirname(__FILE__));
  
  my @dirs = @ARGV;
  my $currDir = getcwd;
  foreach my $dir (@dirs){

    chdir $currDir;
    chdir $dir;
    my $ans = qx($execDir/print_files.pl);
    $ans =~ s/\s*$//g;
    my @files = split(/\s+/, $ans);
    my $line = $dir;

    my @tdis;
    
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
      push(@tdis, $tdi);
    }

    $line =~ s/\s*$//g;
    if (scalar(@tdis) != 2 || $tdis[0] != $tdis[1]){
      next;
    }
    
    print "$line\n";
  }
  
}
