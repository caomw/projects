clear;
%D=imread('results_1mpp_256_1024/res-D.tif');
%D = D(1025:1281, 257:511, :);

%s=1000;
%a=2000+s; b=2000-s; % y
%c=1; d=671; % x
%dir='run_nomap2';

numCols = 256; numRows = 256;
leftImage = zeros(numCols, numRows);
rightImage = zeros(numCols, numRows);
if 1 == 1
for col=1:numCols
   for row = 1:numRows
      x = col - numCols/2-20;
      y = row+21;
      leftImage(col, row) = exp(-(x-0.1*y)^2/y/20);
      x = x-0.5;
      rightImage(col, row) = exp(-(x-0.1*y)^2/y/20);
%      x = col - numCols/2;
%      y = row - numRows/2;
%      %leftImage(col, row)  = exp(-(x^2+y^2)/80^2);
%      leftImage(col, row)  = 1/((x^2+y^2)/50^2+1);
%      x = x-0.5;
%      %rightImage(col, row) = exp(-(x^2+y^2)/80^2);
%      rightImage(col, row)  = 1/((x^2+y^2)/50^2+1);
   end
end

fid = fopen('left.txt', 'w');
for col=1:numCols
   for row = 1:numRows
      fprintf(fid, '%0.20g ', leftImage(col, row));
   end
   fprintf(fid, '\n');
end
fid = fopen('right.txt', 'w');
for col=1:numCols
   for row = 1:numRows
      fprintf(fid, '%0.20g ', rightImage(col, row));
   end
   fprintf(fid, '\n');
end
end

clear;

a=1; b=255; % y
c=1; d=255; % x
%dir='run_nomap3';
dir='small';


figure(6); clf; 
leftImage = load('left.txt');
rightImage = load('right.txt');

pad=50;
[numCols, numRows] = size(leftImage);

imagesc(leftImage(pad:(numCols-pad+1), pad:(numRows-pad))'); colorbar;


%F=imread('results_1mpp_256_1024/res-F.tif');
%F = F(1025:1281, 257:511, :);
%F=imread('results_1mpp_big/res-F.tif');
%F = F(769:1536, 1:672, :);
%dir='res_run6_1mpp_subpix21_crop500_500_500_15000';
%F=imread([dir '/res-F.tif']);
%[numCols, numRows, r] = size(F);
%F=F(1:numCols, numRows:-1:1, 1:r);
%F=F(a:(a+b), c:(c+d), :);

%RD=imread([dir '/res-RD.tif']);
%[numCols, numRows, r] = size(RD);
%RD=RD(1:numCols, numRows:-1:1, 1:r);
%RD=RD(a:(a+b), c:(c+d), :);
%
%prev_file = [dir '/res-RD22.tif'];
%
%   RD_prev=imread(prev_file);
%   [numCols, numRows, r] = size(RD_prev);
%   RD_prev=RD_prev(1:numCols, numRows:-1:1, 1:r);
%   RD_prev=RD_prev(a:(a+b), c:(c+d), :);
%end

%[numCols, numRows, r] = size(RD);

Dx = load('disparity_x.txt');
Dy = load('disparity_y.txt');

do_prev = 1;
if do_prev
   Dx_prev = load('disparity_x16.txt');
   Dy_prev = load('disparity_y16.txt');
end

%figure(1); clf; imagesc(Dx(pad:(numCols-pad+1), pad:(numRows-pad))'); colorbar; axis equal; colorbar;
%title('disparity x')
%figure(2); clf; imagesc(Dy(pad:(numCols-pad+1), pad:(numRows-pad))'); colorbar; axis equal; colorbar;
%title('disparity y')

figure(1); clf; Fx=load('filtered_x.txt'); imagesc(Fx); title('filtered left');
figure(2); clf; Fy=load('filtered_y.txt'); imagesc(Fy); title('filtered right');
figure(8); imagesc(Fx-Fy);

%[numCols, numRows, r] = size(RD);
figure(5); clf; hold on;
title('x')
plot(Dx(pad:(numCols-pad+1), round(numRows/2)), 'b')% goes in x
plot(leftImage(pad:(numCols-pad+1), round(numRows/2)), 'b')% goes in x
plot(rightImage(pad:(numCols-pad+1), round(numRows/2)), 'b')% goes in x
plot(Dx(round(numCols/2), pad:(numRows-pad)), 'r')% goes in y
plot(leftImage(round(numCols/2), pad:(numRows-pad)), 'r')% goes in y
plot(rightImage(round(numCols/2), pad:(numRows-pad)), 'r')% goes in y

if do_prev
   plot(Dx_prev(pad:(numCols-pad+1), round(numRows/2)), 'g')% goes in x
   plot(Dx_prev(round(numCols/2), pad:(numRows-pad)), 'c')% goes in y
end

figure(4); clf; hold on;
title('y')
plot(Dy(pad:(numCols-pad+1), round(numRows/2)), 'b')% goes in x
plot(leftImage(pad:(numCols-pad+1), round(numRows/2)), 'b')% goes in x
plot(Dy(round(numCols/2), pad:(numRows-pad)), 'r')% goes in y
plot(leftImage(round(numCols/2), pad:(numRows-pad)), 'r')% goes in y

if do_prev
   plot(Dy_prev(pad:(numCols-pad+1), round(numRows/2)), 'g')% goes in x
   plot(Dy_prev(round(numCols/2), pad:(numRows-pad)), 'c')% goes in y
end
