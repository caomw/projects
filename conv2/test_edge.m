Iu = imread('left_unflt_0_0_1020_1020_0.tif');
BW = edge(Iu,'sobel', 0.0);
imshow(BW);

