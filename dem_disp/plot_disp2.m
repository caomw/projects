function ans = plot_disp(r)

   rn = sprintf('%d', r);

   if r == 1
      file='nomap_seed2_subpix2/res-D_sub2_prev.tif';
      H = figure(1); set(H, 'Position', [0   400 500 500]);
      title('D_sub prev')
   else
      file='nomap_seed2_subpix2/res-D_sub2.tif';
      H = figure(4); set(H, 'Position', [600 400 500 500]);
      title('D_sub curr')
   end
   disp(sprintf('reading %s', file));
   A=imread(file);

%   
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);

   disp(sprintf('min max X %g %g', min(min(X)), max(max(X))));
   disp(sprintf('min max Y %g %g', min(min(Y)), max(max(Y))));
   
   b=5;

   X = min(X, b); X = max(X, -b);
   Y = min(Y, b); Y = max(Y, -b);
   
   subplot(2, 2, 1); imagesc(X); colorbar; title('disp x')
   subplot(2, 2, 2); imagesc(Y); colorbar; title('disp y')
   subplot(2, 2, 3); imagesc(V); colorbar; title('is valid')

%   [m, n] = size(V);
%   I = find(V ~= 0);
%   XV = X(I); YV = Y(I);
%   disp(sprintf('total pct and mean of and std of x: %d %g %g %g', m*n, length(XV)/(m*n), mean(XV), std(XV)));
%   disp(sprintf('total pct and mean of and std of y: %d %g %g %g', m*n, length(YV)/(m*n), mean(YV), std(YV)));

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
%   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
%   Ifs=abs(If);
%   imagesc(Ifs); axis on; colorbar;
