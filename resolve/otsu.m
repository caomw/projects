% oblique: sub16_cubes_45deg/AS15-M-1514.lev1.cub

% The image must be between 0 and 1
f='85s_10w/M139939938LE.cal_sigma0.tif';
f='85s_10w/M139946735RE.cal_sigma0.tif';
f='AS15-M-1511.lev1_sigma0.tif';
f='85s_10w/M139960308RE.cal_sigma0.tif';

I=im2double(min(1, max(0, imread(f))));

[m, n] = size(I);
K = reshape(double(I), m*n, 1); H = hist(K, 256);
level = graythresh(I);
X=linspace(0, 1, 256);

figure(3); clf; hold on;
%axis([0, 0.1, 0, 5e5]) 
plot(X, H);
plot(level, 0, 'r*');

figure(1); clf; hold on;
%imshow(I);
BW = im2bw(I,level);
imshow(BW);


figure(6); clf; hold on;
%imshow(I);
BW = im2bw(I,0.04);
imshow(BW);

%
%
%
%I=im2double(min(1, max(0, imread('pic3o.tif'))));
%[m, n] = size(I);
%K = reshape(double(I), m*n, 1); H = hist(K, 256);
%level = graythresh(I);
%X=linspace(0, 1, 256);
%
%figure(2); clf; hold on;
%plot(X, H);
%plot(level, 0, 'r*');
%axis([0, 0.1, 0, 5e5]) 
