files={'results_10mpp_M139939938LE_M139946735RE/M139939938LE_rc_sc_sigma0.tif',
       'results_10mpp_M139939938LE_M139946735RE/M139946735RE_rc_sc_sigma0.tif',
       'results_10mpp_M139946735LE_M139953510RE/M139946735LE_rc_sc_sigma0.tif',
       'results_10mpp_M139946735LE_M139953510RE/M139953510RE_rc_sc_sigma0.tif',
       'results_10mpp_M139926365LE_M139933163RE/M139926365LE_rc_sc_sigma0.tif',
       'results_10mpp_M139926365LE_M139933163RE/M139933163RE_rc_sc_sigma0.tif',
       'results_10mpp_M139953510LE_M139960308RE/M139953510LE_rc_sc_sigma0.tif',
       'results_10mpp_M139953510LE_M139960308RE/M139960308RE_rc_sc_sigma0.tif',
       'results_10mpp_M139933163LE_M139939938RE/M139933163LE_rc_sc_sigma0.tif',
       'results_10mpp_M139933163LE_M139939938RE/M139939938RE_rc_sc_sigma0.tif',
       'results_10mpp_M139906018LE_M139912793RE/M139906018LE_rc_sc_sigma0.tif',
       'results_10mpp_M139906018LE_M139912793RE/M139912793RE_rc_sc_sigma0.tif',
       'results_10mpp_M139919591LE_M139926365RE/M139919591LE_rc_sc_sigma0.tif',
       'results_10mpp_M139919591LE_M139926365RE/M139926365RE_rc_sc_sigma0.tif',
       'results_10mpp_M139912793LE_M139919591RE/M139912793LE_rc_sc_sigma0.tif',
       'results_10mpp_M139912793LE_M139919591RE/M139919591RE_rc_sc_sigma0.tif',
       'AS15-M-1514.lev1_sigma0.tif',
       'AS15-M-1430.lev1_sigma0.tif',
       'AS15-M-1559.lev1_sigma0.tif',
       'AS15-M-1470.lev1_sigma0.tif',
       'AS15-M-1540.lev1_sigma0.tif',
       'AS15-M-1490.lev1_sigma0.tif',
       'AS15-M-1525.lev1_sigma0.tif'};

figure(1); clf; hold on;
colors={'r', 'g', 'b', 'c', 'm', 'k', 'y'};

pct = 0.48;
factor = 0.1;
Rview = 40;
thresh = 0.03;
ht=1.2;

M = 0;
figure(1); clf; hold on;

for l=1:length(files)
%for l=1:16
   
   file = files{l};
   disp(sprintf('Reading %s', file));
   I = imread(file);
   H = imhist(I, 256);
   M = max(M, max(H));

   figure(1);
   col = colors{rem(l-1, 7)+1};
   shift = l*0.05*M;
   plot(H + shift, col);
   axis([0, Rview, 0, shift + M*ht]);

   z = pctile(H, pct);
   z = min(length(H), max(1, round(z)));
   plot(z, H(z)+shift, 'k*');

   t = max(1, thresh*255);
   t = min(length(H), max(1, round(t)));
   plot(t, H(t)+shift, 'g*');

   t = graythresh(I)*255*factor;
   t = min(length(H), max(1, round(t)));
   plot(t, H(t)+shift, 'r*');

%   figure(2); clf;
%   try
%      imshow(I); 
%   catch
%   end
%   pause(2);
   
end