function ans = plot_disp(level, r)

   pref = '0_0_510_510';
   pref2='0_0_1020_1020';
   l = sprintf('%d', level);
   rn = sprintf('%d', r);
   
   file = ['run' rn '/disparity_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   A=imread(file);

%   if r == 3
%      H = figure(1); set(H, 'Position', [0 600 300 300]);
%   else
%      H = figure(4); set(H, 'Position', [600 600 300 300]);
%   end
%   
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);
%   subplot(2, 2, 1); imagesc(X); colorbar;
%   subplot(2, 2, 2); imagesc(Y); colorbar;
%   subplot(2, 2, 3); imagesc(V); colorbar;
%
   [m, n] = size(V);
   I = find(V ~= 0);
   XV = X(I); YV = Y(I);
   disp(sprintf('total pct and mean of and std of x: %d %g %g %g', m*n, length(XV)/(m*n), mean(XV), std(XV)));
   disp(sprintf('total pct and mean of and std of y: %d %g %g %g', m*n, length(YV)/(m*n), mean(YV), std(YV)));

%   file = ['run' rn '/left_level_' pref2 '_' l '.tif'];
%   disp(sprintf('reading %s', file));
%   If=imread(file);
%   disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
%   if r == 3
%      H = figure(3); set(H, 'Position', [300 600 300 300]);
%   else
%      H = figure(5); set(H, 'Position', [900 600 300 300]);
%   end
%   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
%   Ifs=abs(If);
%   imagesc(Ifs); axis on; colorbar;
%   %imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
