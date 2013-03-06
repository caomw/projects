function V = levels(level, r, skip_plot)

   skip_plot = 0;
   if nargin >= 3
      skip_plot = 1;
   end
   disp(sprintf('skip plot is %g', skip_plot));
   
   %pref='25600_0_1024_1024'; % sub1
   %pref='13312_0_1024_1024'; % sub2
   %pref='14336_0_1024_1024';
   pref='0_0_1020_1020';
   
   l = sprintf('%d', level);
   rn = sprintf('%d', r);
   
   file = ['run' rn '/left_img_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   Iu=imread(file);
   disp(sprintf('min and max are: %g %g', min(min(Iu)), max(max(Iu))));
   if skip_plot == 0
      H = figure(1); set(H, 'Position', [0 600 300 300]);
      imshow(Iu, 'InitialMagnification', 'fit'); axis on; colorbar;
   end

   x_mask = 8*[0.1250         0   -0.1250; 0.2500         0   -0.2500; 0.1250         0   -0.1250];
   y_mask = 8*[0.1250    0.2500    0.1250; 0         0         0; -0.1250   -0.2500   -0.1250];
   bx = imfilter(Iu,x_mask,'replicate');
   by = imfilter(Iu,y_mask,'replicate');
   S = bx.*bx + by.*by;
   %th=0.005;
   %T = 0*S; T(find(S > th)) = 1; 
   %S = T;
   
   sum_val = 0;
   count = 0;
   [m, n] = size(S);
   deriv = sum(sum(S))/(m*n);
   V(1) = deriv;
   disp(sprintf('------sobel sum level %d is %0.20g', level, deriv));
   if skip_plot == 0
      H = figure(2); set(H, 'Position', [300 600 300 300]);
      imagesc(S); axis on; colorbar; title('deriv'); colormap gray;
      %H = figure(7); set(H, 'Position', [900 200 300 300]);
      %imagesc(T); axis on; colorbar; title('deriv'); colormap gray;
   end

%   disp(sprintf('S min and max %g %g', min(min(S)), max(max(S))));

%   file = ['run' rn '/sobel_img_' pref '_' l '.tif'];
%   disp(sprintf('reading %s', file));
%   Sc=imread(file);
%   disp(sprintf('Sc min and max %g %g', min(min(Sc)), max(max(Sc))));
%   %figure(1); clf; hold on; imagesc(S);
%   %figure(2); clf; hold on; imagesc(Sc);
%   disp(sprintf('error %g', max(max(abs(Sc-S)))));
%   %return;
%   
%   file = ['run' rn '/left_flt_' pref '_' l '.tif'];
%   disp(sprintf('reading %s', file));
%   If=imread(file);
%   disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
%   H = figure(3); set(H, 'Position', [400 600 400 400]);
%   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
%   Ifs=abs(If);
%   imagesc(Ifs); axis on; colorbar;
%   %imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;

%   mn = min(min(Iu)); mx = max(max(Iu)); 
%   %BW = edge(Iu,'sobel', (mn + mx)/2.0);
%   %BW = edge(Iu,'sobel', 0.2);
   BW = edge(Iu,'sobel', 0.008);
   %BW = edge(Iu,'sobel');
%   %%%BW = edge(I,'sobel',thresh);
%   %%%BW = edge(I,'sobel',thresh,direction);
%   %%%[BW,thresh] = edge(I,'sobel',...);
   if skip_plot == 0
      H = figure(3); set(H, 'Position', [600 600 300 300]);
      imshow(BW, 'InitialMagnification', 'fit'); axis on; title('sobel'); colorbar;
   end
   
   [m, n] = size(BW);
   sb = sum(sum(BW))/(m*n);
   disp(sprintf('sb is %g', sb));
   V(2) = sb;

%   if skip_plot == 0
%      for r = 1:2
%         rn = sprintf('%d', r);
%         file = ['run' rn '/left_img_' pref '_' l '.tif'];
%         disp(sprintf('reading %s', file));
%         Iu=imread(file);
%         th = 0.008;
%         BW = edge(Iu,'sobel', th);
%         H = figure(3); set(H, 'Position', [600 600 300 300]);
%         clf; subplot(2, 2, r);
%         imshow(BW, 'InitialMagnification', 'fit'); axis on; title('sobel'); colorbar;
%         title('run %s th=%d', rn, th)
%      end
%   end
   
%   figure(5);
%   if r == 1
%      plot(level, sb, 'r*')
%   else
%      plot(level, sb, 'c*')
%   end
   
%   sum = 0;
%   count = 0;
%   for i=1:m
%      for j=1:n
%         sum = sum + BW(i, j);
%         count = count + 1;
%      end
%   end
%   ans = sum/count;

%   file = ['run' rn '/right_img_' pref '_' l '.tif'];
%   disp(sprintf('reading %s', file));
%   Iu=imread(file);
%   disp(sprintf('min and max are: %g %g', min(min(Iu)), max(max(Iu))));
%   H = figure(5); set(H, 'Position', [0 220 300 300]);
%   imshow(Iu, 'InitialMagnification', 'fit'); axis on; colorbar;
%   
%
%   file = ['run' rn '/right_flt_' pref '_' l '.tif'];
%   disp(sprintf('reading %s', file));
%   If=imread(file);
%   disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
%   H = figure(6); set(H, 'Position', [400 220 300 300]);
%   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
%   Ifs=abs(If);
%   imagesc(Ifs); axis on; colorbar;
%   %imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
   
%   BW = edge(If,'sobel');
%   %%%BW = edge(I,'sobel',thresh);
%   %%%BW = edge(I,'sobel',thresh,direction);
%   %%%[BW,thresh] = edge(I,'sobel',...);
%   H = figure(4); set(H, 'Position', [1200 600 300 300]);
%   imshow(BW, 'InitialMagnification', 'fit'); title('sobel flt')
   
%
%BW = edge(I,'prewitt');
%%BW = edge(I,'prewitt',thresh);
%%BW = edge(I,'prewitt',thresh,direction);
%%[BW,thresh] = edge(I,'prewitt',...);
%
%BW = edge(I,'roberts');
%%BW = edge(I,'roberts',thresh);
%%[BW,thresh] = edge(I,'roberts',...);
%figure(3); clf; hold on; imshow(BW);
%
%BW = edge(I,'log');
%%BW = edge(I,'log',thresh);
%%BW = edge(I,'log',thresh,sigma);
%%[BW,threshold] = edge(I,'log',...);
%
%%BW = edge(I,'zerocross',thresh,h);
%%[BW,thresh] = edge(I,'zerocross',...);
%
%BW = edge(I,'canny');
%%BW = edge(I,'canny',thresh);
%%BW = edge(I,'canny',thresh,sigma);
%%[BW,threshold] = edge(I,'canny',...);
