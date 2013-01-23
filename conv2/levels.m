function ans = levels(level, rn)

   %pref='25600_0_1024_1024'; % sub1
   %pref='13312_0_1024_1024'; % sub2
   %pref='14336_0_1024_1024';
   pref='0_0_1020_1020';
   
   l = sprintf('%d', level);
   rn = sprintf('%d', rn);
   
   file = ['run' rn '/left_unflt_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   Iu=imread(file);
   disp(sprintf('min and max are: %g %g', min(min(Iu)), max(max(Iu))));
   H = figure(1); set(H, 'Position', [0 600 300 300]);
   imshow(Iu, 'InitialMagnification', 'fit'); axis on; colorbar;
   
   file = ['run' rn '/left_level_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   If=imread(file);
   disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
   H = figure(3); set(H, 'Position', [400 600 400 400]);
   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
   Ifs=abs(If);
   imagesc(Ifs); axis on; colorbar;
   %imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;

   mn = min(min(Iu)); mx = max(max(Iu)); 
   %BW = edge(Iu,'sobel', (mn + mx)/2.0);
   %BW = edge(Iu,'sobel', 0.2);
   BW = edge(Iu,'sobel', 0.0);
   %%%BW = edge(I,'sobel',thresh);
   %%%BW = edge(I,'sobel',thresh,direction);
   %%%[BW,thresh] = edge(I,'sobel',...);
   H = figure(2); set(H, 'Position', [800 600 300 300]);
   imshow(BW, 'InitialMagnification', 'fit'); axis on; title('sobel'); colorbar;
   [m, n] = size(BW);
   sum = 0;
   count = 0;
   for i=1:m
      for j=1:n
         sum = sum + BW(i, j);
         count = count + 1;
      end
   end
   ans = sum/count;

   file = ['run' rn '/right_unflt_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   Iu=imread(file);
   disp(sprintf('min and max are: %g %g', min(min(Iu)), max(max(Iu))));
   H = figure(5); set(H, 'Position', [0 220 300 300]);
   imshow(Iu, 'InitialMagnification', 'fit'); axis on; colorbar;
   

   file = ['run' rn '/right_level_' pref '_' l '.tif'];
   disp(sprintf('reading %s', file));
   If=imread(file);
   disp(sprintf('min and max are: %g %g', min(min(If)), max(max(If))));
   H = figure(6); set(H, 'Position', [400 220 300 300]);
   %mn = min(min(If)); mx = max(max(If)); Ifs = (If - mn)/(mx - mn);
   Ifs=abs(If);
   imagesc(Ifs); axis on; colorbar;
   %imshow(If, 'InitialMagnification', 'fit'); axis on; colorbar;
   
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
