#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

my $lic = '//__BEGIN_LICENSE__
//  Copyright (c) 2009-2012, United States Government as represented by the
//  Administrator of the National Aeronautics and Space Administration. All
//  rights reserved.
//
//  The NGT platform is licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance with the
//  License. You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// __END_LICENSE__';

MAIN:{
  
  foreach my $file (<*.*[hcx]>){
    print "$file\n";

    open(FILE, "<$file");
    my $text = join("", <FILE>);
    close(FILE);
    $text =~ s/__BEGIN_LICENSE__.*?__END_LICENSE__/$lic/sg;
    
    open(FILE, ">$file");
    print FILE "$text";
    close(FILE);
  }
  
}
