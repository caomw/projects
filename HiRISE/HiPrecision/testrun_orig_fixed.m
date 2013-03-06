function testrun_orig_fixed(imageid, flat1, flat2, flat3)

   imagelocation = './';
   from1         = -1;
   from2         = -1;
   from3         = -1;
   lineinterval  = 20;
   
% $$$ imageid = 'PSP_001521_2025';
% $$$ flat1   = 'PSP_001521_2025_RED3-RED4.flat.tab';
% $$$ flat2   = 'PSP_001521_2025_RED5-RED4.flat.tab';
% $$$ flat3   = 'PSP_001521_2025_BG12-RED4.flat.tab';

%imageid = 'PSP_002158_2035';
%flat1   = 'PSP_002158_2035_RED4-RED5.flat.tab';
%flat2   = 'PSP_002158_2035_RED6-RED5.flat.tab';
%flat3   = 'PSP_002158_2035_IR11-RED5.flat.tab';

[Sample,Line,ET,AverageError]=createPVLforHiJACK_orig_fixed(imagelocation, imageid, lineinterval, flat1, from1, flat2, from2, flat3, from3);
