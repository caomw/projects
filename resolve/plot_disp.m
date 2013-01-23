function main(mid, pref)
 
Dy  = imread(['Dy' pref '.tif']);
RDy = imread(['RDy' pref '.tif']);
Dx  = imread(['Dx' pref '.tif']);
RDx = imread(['RDx' pref '.tif']);

figure(1); clf; hold on;
imagesc(Dy); colormap gray;
title('Dy')

figure(2); clf; hold on;
imagesc(RDy); colormap gray;
title('RDy')

[m, n] = size(Dy)

figure(3); clf; hold on;
plot(Dy(:, mid),  'b');
plot(RDy(:, mid), 'r');
title('Dy in x')

figure(4); clf; hold on;
plot(Dy(mid, :),  'b');
plot(RDy(mid, :), 'r');
title('Dy in y')


figure(5); clf; hold on;
imagesc(Dx); colormap gray;
title('Dx')

figure(6); clf; hold on;
imagesc(RDx); colormap gray;
title('RDx')

[m, n] = size(Dx);

figure(7); clf; hold on;
plot(Dx(:, mid),  'b');
plot(RDx(:, mid), 'r');
title('Dx in x')

figure(8); clf; hold on;
plot(Dx(mid, :),  'b');
plot(RDx(mid, :), 'r');
title('Dx in y')
