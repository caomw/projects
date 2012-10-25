%I=load('inputImage.txt');
%[m, n] = size(I);
%figure(1); clf; hold on;
%imagesc(I); title('inputImage')
%colorbar; axis ij; colormap gray;
%
D0=load('sfsDEM0.txt');
[m, n] = size(D0);
figure(2); clf; hold on;
imagesc(D0); title('sfsDEM0')
colorbar; axis ij; colormap gray;

D1=load('sfsDEM1.txt');
[m, n] = size(D1);
figure(3); clf; hold on;
imagesc(D1); title('sfsDEM1')
colorbar; axis ij; colormap gray;

U1=load('update1.txt');
[m, n] = size(U1);
figure(5); clf; hold on;
imagesc(U1); title('update1')
colorbar; axis ij; colormap gray;

disp(sprintf('min and max of update1 is %g %g', min(min(U1)), max(max(U1))));

%
%E=load('error.txt');
%figure(4); clf; hold on;
%imagesc(E); title('Error')
%colorbar; axis ij; colormap gray;
%
%R=load('reflectance.txt');
%figure(5); clf; hold on;
%imagesc(R); title('Reflectance')
%colorbar; axis ij; colormap gray;
%
%A=load('albedoImage.txt');
%figure(6); clf; hold on;
%imagesc(A); title('Albedo')
%colorbar; axis ij; colormap gray;
%
%A=load('albedoImage.txt');
%r=1.2248920202255249023;
%[m, n] = size(A);
%figure(7); clf; hold on;
%E2 = I - r*(R(1:m, 1:n).*A);
%imagesc(E2); title('matlab error')
%colorbar; axis ij; colormap gray;
%
%figure(8); clf; hold on;
%Et = E(1:m, 1:n) - E2;
%imagesc(Et); title('eror diff')
%colorbar; axis ij; colormap gray;
%
%%
%%E=load('update16.txt');
%%[m, n] = size(E);
%%figure(2); clf; hold on;
%%%E = atan(E);
%%E = E(200:300,300:400);
%%imagesc(E);
%%% $$$ s = 400;
%%% $$$ imagesc(min(max(-s, E), s));
%%colorbar; axis ij; colormap gray;
%%
%%figure(3); clf; hold on;
%%imagesc(E - D);
%%% $$$ s = 400;
%%% $$$ imagesc(min(max(-s, E), s));
%%colorbar; axis ij; colormap gray;
%%
%%%colormap gray;
%%%  
%%%  S=load('sfs.txt');
%%%  [m, n] = size(S);
%%%  figure(2); clf; hold on;
%%%  imagesc(min(max(-4000, S), 1000));
%%%  colorbar; axis ij;
%%%  colormap gray;
%%%  
%%%  figure(3); clf; hold on;
%%%  imagesc(min(max(-400, S - D), 100));
%%%  colorbar; axis ij;
%%%  colormap gray;
%%%  
%%%  %figure(2); clf;
%%%  %T = reshape(S, m*n, 1);
%%%  %hist(T, 5000);
