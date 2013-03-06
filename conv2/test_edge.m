thresh = 0.03;

Iu = imread('left_unflt_0_0_1020_1020_0.tif');
H = figure(1); set(H, 'Position', [0 600 300 300]);
imshow(Iu, 'InitialMagnification', 'fit'); axis on; colorbar;

disp(sprintf('min and max are %g %g', min(min(Iu)), max(max(Iu))));

BW = edge(Iu,'sobel', thresh, 'nothinning');

H = figure(3); set(H, 'Position', [300 600 300 300]);
imshow(BW, 'InitialMagnification', 'fit'); axis on; title('sobel'); colorbar;

BW2 = edge2(Iu,'sobel', thresh, 'nothinning');

disp(sprintf('error is %g', max(max(abs(BW-BW2)))));

Ic = imread('sobel_cpp.tif');
H = figure(4); set(H, 'Position', [600 600 300 300]);
imshow(Ic, 'InitialMagnification', 'fit'); axis on; title('cpp'); colorbar;

x_mask = 8*[0.1250         0   -0.1250; 0.2500         0   -0.2500; 0.1250         0   -0.1250];
y_mask = 8*[0.1250    0.2500    0.1250; 0         0         0; -0.1250   -0.2500   -0.1250];


bx = imfilter(Iu,x_mask,'replicate');
by = imfilter(Iu,y_mask,'replicate');
b = bx.*bx + by.*by;
%figure(3); imshow(b, 'InitialMagnification', 'fit'); axis on; title('sobel'); colorbar;
disp(sprintf('min and max M are %g %g', min(min(b)), max(max(b))));
disp(sprintf('min and max C are %g %g', min(min(Ic)), max(max(Ic))));
Q = b - Ic;
figure(3); clf; imagesc(Q); colorbar;
disp(sprintf('min and max are %g %g', min(min(Q)), max(max(Q))));


