function main()
   files={'results_1mpp_M139906018LE_M139912793RE/res-L.txt',
'results_1mpp_M139906018LE_M139912793RE/res-R.txt',
'results_1mpp_M139912793LE_M139919591RE/res-L.txt',
'results_1mpp_M139912793LE_M139919591RE/res-R.txt',
'results_1mpp_M139919591LE_M139926365RE/res-L.txt',
'results_1mpp_M139919591LE_M139926365RE/res-R.txt',
'results_1mpp_M139926365LE_M139933163RE/res-L.txt',
'results_1mpp_M139926365LE_M139933163RE/res-R.txt',
'results_1mpp_M139933163LE_M139939938RE/res-L.txt',
'results_1mpp_M139933163LE_M139939938RE/res-R.txt',
'results_1mpp_M139939938LE_M139946735RE/res-L.txt',
'results_1mpp_M139939938LE_M139946735RE/res-R.txt',
'results_1mpp_M139946735LE_M139953510RE/res-L.txt',
'results_1mpp_M139946735LE_M139953510RE/res-R.txt',
'results_1mpp_M139953510LE_M139960308RE/res-L.txt',
'results_1mpp_M139953510LE_M139960308RE/res-R.txt'
      };

figure(1); clf; hold on;
colors={'r', 'g', 'b', 'c', 'm', 'k', 'y'};


pct = 0.48;
factor = 0.1;
Rview = 0.6;
thresh = 0.038;
ht=1.2;
M = 0.0;
Mx = 0;

for l=1:length(files)
   
   file = files{l};
   disp(sprintf('Reading %s', file));
   H = load(file);

   HH=H; H = log(H);
   
   X=linspace(0, 1, length(H));
   figure(1);
   col = colors{rem(l-1, 7)+1};
   Mx = max(Mx, max(H));
   shift = l*0.08*Mx;
   try
      plot(X, H + shift, col);
   catch
   end
   
   hold on;
   axis([0, Rview, 0, 2*Mx]);

   t = max(1, thresh*(length(H)-1));
   t = min(length(H), max(1, round(t)));
   plot(thresh, H(t)+shift, 'g*');

   thresh2 = 0.18*otsu(HH);
   t = max(1, thresh2*(length(H)-1));
   t = min(length(H), max(1, round(t)));
   plot(thresh2, H(t)+shift, 'r*');
   
end

function level = otsu(H)

  % Variables names are chosen to be similar to the formulas in
  % the Otsu paper.
   counts = H';
   num_bins = length(H);
   
  p = counts / sum(counts);
  omega = cumsum(p);
  mu = cumsum(p .* (1:num_bins)');
  mu_t = mu(end);
  
  sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

  % Find the location of the maximum value of sigma_b_squared.
  % The maximum may extend over several bins, so average together the
  % locations.  If maxval is NaN, meaning that sigma_b_squared is all NaN,
  % then return 0.
  maxval = max(sigma_b_squared);
  isfinite_maxval = isfinite(maxval);
  if isfinite_maxval
    idx = mean(find(sigma_b_squared == maxval));
    % Normalize the threshold to the range [0, 1].
    level = (idx - 1) / (num_bins - 1);
  else
    level = 0.0;
  end

