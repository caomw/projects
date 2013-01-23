function levels(level)

   %pref='25600_0_1024_1024'; % sub1
   pref='13312_0_1024_1024'; % sub2
   pref='14336_0_1024_1024';
   
   l = sprintf('%d', level);
   
   file = ['left_level_' pref '_' l '_scaled.tif'];
   disp(sprintf('reading %s', file));
   I=imread(file);
   H = figure(1); set(H, 'Position', [0 600 300 300]);
   imshow(I, 'InitialMagnification', 'fit');
   
   file = ['left_unflt_' pref '_' l '_scaled.tif'];
   disp(sprintf('reading %s', file));
   I=imread(file);
   H = figure(3); set(H, 'Position', [400 600 300 300]);
   imshow(I, 'InitialMagnification', 'fit');
   

%
%
%%
%BW = edge(I,'sobel');
%%%BW = edge(I,'sobel',thresh);
%%%BW = edge(I,'sobel',thresh,direction);
%%%[BW,thresh] = edge(I,'sobel',...);
%H = figure(2); set(H, 'Position', [300 600 300 300]);
%imshow(BW, 'InitialMagnification', 'fit');
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
