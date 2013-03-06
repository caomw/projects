function ans = plot_disp_tmp(level)

   pref = '0_0_510_510';
   pref2='0_0_1020_1020';
   l = sprintf('%d', level);
   %rn = sprintf('%d', r);
   
   file = ['before_disparity_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   A=imread(file);

   H = figure(1); set(H, 'Position', [0 400 500 500]); axis off;
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);
   subplot(2, 2, 1); imagesc(X); colorbar; title('bdisp x'); axis off;
   subplot(2, 2, 2); imagesc(Y); colorbar; title('bdisp y'); axis off;
   subplot(2, 2, 3); imagesc(V); colorbar; title('bis valid'); axis off;

   file = ['after_disparity_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   A=imread(file);
   H = figure(4); set(H, 'Position', [550 400 500 500]);
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);
   subplot(2, 2, 1); imagesc(X); colorbar; title('adisp x'); axis off;
   subplot(2, 2, 2); imagesc(Y); colorbar; title('adisp y'); axis off;
   subplot(2, 2, 3); imagesc(V); colorbar; title('ais valid'); axis off;

   file = ['after2_disparity_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   A=imread(file);
   H = figure(5); set(H, 'Position', [560 200 500 500]);
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);
   subplot(2, 2, 1); imagesc(X); colorbar; title('adisp x'); axis off;
   subplot(2, 2, 2); imagesc(Y); colorbar; title('adisp y'); axis off;
   subplot(2, 2, 3); imagesc(V); colorbar; title('ais valid'); axis off;

   
%
%   [m, n] = size(V);
%   I = find(V ~= 0);
%   XV = X(I); YV = Y(I);
%   disp(sprintf('total pct and mean of and std of x: %d %g %g %g', m*n, length(XV)/(m*n), mean(XV), std(XV)));
%   disp(sprintf('total pct and mean of and std of y: %d %g %g %g', m*n, length(YV)/(m*n), mean(YV), std(YV)));
%
%   if r == 2
%      file = ['run_l' '3' '/left_img_' pref2 '_' '2' '.tif'];
%      disp(sprintf('reading %s', file));
%      If=imread(file);
%      disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
%      H = figure(3); set(H, 'Position', [300 600 300 300]);
%      imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
%      title('left')
%   else
%      file = ['run_l' '3' '/right_img_' pref2 '_' '2' '.tif'];
%      disp(sprintf('reading %s', file));
%      If=imread(file);
%      disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
%      H = figure(5); set(H, 'Position', [900 600 300 300]);
%      imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
%      title('right')
%   end
%%   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
%%   Ifs=abs(If);
%%   imagesc(Ifs); axis on; colorbar;
