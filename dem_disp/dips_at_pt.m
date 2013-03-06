function ans = disp_at_pt(i, j, file);

   disp(sprintf('reading %s', file));
   A=imread(file);

%   
   X = A(:, :, 1);
   Y = A(:, :, 2);
   V = A(:, :, 3);

   i = round(i);
   j = round(j);
   disp(sprintf('value is %g %g %g', X(i, j), Y(i, j), V(i, j)));

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
