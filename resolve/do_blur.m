function do_blur(p)
M=load('matrix.txt');

size(M)

%figure(1); clf; hold on;
%imagesc(M);
%title('orig'); colormap gray;


F = fft2(M);

[m, n] = size(F);
disp(sprintf('fft size is %d %d', m, n));
%p = 0.9;
m0 = 2*round(p*0.5*m);
n0 = 2*round(p*0.5*n);

file=sprintf('mat_%d_%d.txt', m0, n0);
disp(sprintf('Saving %s', file));


lm=max(1, (m/2-m0)); um=min(m, (m/2+m0));
ln=max(1, (n/2-n0)); un=min(n, (n/2+n0));


Q = F;
disp(sprintf('Wiping things from center!'));
Q( lm:um, ln:un ) = 0;

figure(1); clf; imagesc(M); hold on; colormap gray;

figure(2); clf; image(abs(Q)); hold on; colorbar;

N = real(ifft2(Q));

figure(3); clf; imagesc(N); hold on; colorbar; colormap gray;

Y = hist(abs(M-N));
figure(4); clf; hold on;
mesh(Y);

%figure(4); clf; imagesc(abs(M-N)); hold on; colorbar; colormap gray; 

disp(sprintf('diff is %g', max(max(abs(M-N)))));

disp(sprintf('max in is %g', max(max(M))));
disp(sprintf('min in is %g', min(min(M))));

disp(sprintf('max out is %g', max(max(N))));
disp(sprintf('min out is %g', min(min(N))));


save(file, '-ascii', '-double', 'N');

%figure(2); clf; hold on;
%title('blurred')
%imagesc(N); colormap gray;
