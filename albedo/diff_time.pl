#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Date::Parse;
use POSIX qw{strftime};
  MAIN:{

  # Usage: cat output.txt | grep -E "(start|end) job" | diff_time.pl
  
  my @lines = <STDIN>;
  my $count = -1;
  my @dates = ();
  foreach my $line (@lines){
    $count++;
    $line =~ s/^\d*://g; # Rm artifact coming from grep
    $line =~ s/\s*$//g;
    print "$line\n";

    $line =~ s/^.*at\s*(.*?)$/$1/g;
    my $date = str2time($line);
    push (@dates, $date);
    if ($count%2){
      my $diff = $date - $dates[$count-1]; # difference in times in seconds
      print "Diff time is " . print_hours($diff) . " hours (" . print_mins($diff) . " minutes)\n\n";
    }
  }

  my $last = 8;
  if (scalar(@dates) == $last){
    my $diff = $dates[$last - 1] - $dates[0]; # difference in times in seconds
    print "Total time is " . print_hours($diff) . " hours (" . print_mins($diff) . " minutes)\n\n";
  }
}

sub print_hours{
  my $val = shift;
  return  int(100*$val/3600 + 0.5)/100;
}

sub print_mins{
  my $val = shift;
  return  int(100*$val/60 + 0.5)/100;
}
