function ans = plot_disp(level, r)

   pref = '0_0_510_510';
   pref2='0_0_1020_1020';
   l = sprintf('%d', level);
   rn = sprintf('%d', r);
   
   file = ['run_l' rn '/disparity_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   A=imread(file);

   if r == 2
   H = figure(1); set(H, 'Position', [0 600 300 300]);
   else
      H = figure(4); set(H, 'Position', [600 600 300 300]);
   end
%   
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);
   subplot(2, 2, 1); imagesc(X); colorbar; title('disp x')
   subplot(2, 2, 2); imagesc(Y); colorbar; title('disp y')
   subplot(2, 2, 3); imagesc(V); colorbar; title('is valid')

   [m, n] = size(V);
   I = find(V ~= 0);
   XV = X(I); YV = Y(I);
   disp(sprintf('total pct and mean of and std of x: %d %g %g %g', m*n, length(XV)/(m*n), mean(XV), std(XV)));
   disp(sprintf('total pct and mean of and std of y: %d %g %g %g', m*n, length(YV)/(m*n), mean(YV), std(YV)));

   if r == 2
      file = ['run_l' '3' '/left_img_' pref2 '_' '2' '.tif'];
      disp(sprintf('reading %s', file));
      If=imread(file);
      disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
      H = figure(3); set(H, 'Position', [300 600 300 300]);
      imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
      title('left')
   else
      file = ['run_l' '3' '/right_img_' pref2 '_' '2' '.tif'];
      disp(sprintf('reading %s', file));
      If=imread(file);
      disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
      H = figure(5); set(H, 'Position', [900 600 300 300]);
      imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
      title('right')
   end
%   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
%   Ifs=abs(If);
%   imagesc(Ifs); axis on; colorbar;
