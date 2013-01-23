function main()
%function [R, t] = comp_otsu(H)

file = 'results_10mpp_M139919591LE_M139926365RE/M139919591LE_rc_sc_sigma0.tif';

I = imread(file);
%disp(sprintf('max and min are %g %g', min(min(I)), max(max(I))));

J = I;
H2 = hist(double(I(:)), 256);

I = im2uint8(I(:));

%disp(sprintf('2max and min are %g %g', min(min(I)), max(max(I))));

num_bins = 256;
  counts = imhist(I,num_bins);

  counts2 = hist(double(I), num_bins);
  figure(3); clf; hold on;
  plot(counts, 'b');
  plot(counts2, 'r');
  
  disp(sprintf('error is %g', max(abs(counts-counts2'))));
  disp(sprintf('error 3 is %g', max(abs(H2' - counts))))
  
  % temporary!!!
  %counts(1) = 0;
  
  % Variables names are chosen to be similar to the formulas in
  % the Otsu paper.
  p = counts / sum(counts);
  omega = cumsum(p);
  mu = cumsum(p .* (1:num_bins)');
  mu_t = mu(end);
  
  sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

  H = counts;
  
  R = do_otsu(H);

%  figure(1); clf; hold on;
%  plot(sigma_b_squared, 'b');
%
%  figure(2); clf; hold on;
%  plot(R, 'r');

  disp(sprintf('error is %g', max(abs(R-sigma_b_squared))));
%  figure(6); clf; hold on;
%  plot(abs(R-sigma_b_squared))

  t = graythresh(I);
  disp(sprintf('threshold is %0.20g', t));
  
function R = do_otsu(H)
   
  
   P = H/sum(H);
   n = length(P);

   R = 0*H;
   
   %X = linspace(minV, maxV, n);
   X=1:n;
   X = X-1; % temporary!!!
   disp(sprintf('Temporary!!!, first x is %g', X(1)));
   
   totalProb = 0;
   for i=1:n
      totalProb = totalProb + P(i);
   end

   disp(sprintf('totalProb is %g', totalProb));
   
   totalAccum = 0;
   for i=1:n
      totalAccum = totalAccum + X(i)*P(i);
   end

   leftAccum = 0;
   leftProb = 0;
   maxErr = 0;
   t = 0;
   for i=1:n
      leftAccum = leftAccum + X(i)*P(i);
      rightAccum = totalAccum - leftAccum;

      leftProb  = leftProb + P(i);
      rightProb = totalProb - leftProb;

      % Skip points where the denominator is 0!
      
      leftMean = leftAccum/leftProb;
      rightMean = rightAccum/rightProb;

      err = leftProb*rightProb*(leftMean-rightMean)*(leftMean-rightMean);

      R(i) = err;
      
      if i==1
         maxErr = err;
      end

      if err > maxErr
         t = i;
         maxErr = err;
      end
   end
