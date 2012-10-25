%C=20:36; R = 120:136;
%C=1:200;
%R=23:27; C=126:130; %imagesc(R, C, A)

A=load('inputImage.txt');
[m, n] = size(A)

R=97:112; C = 97:112;
%R = 1:m; C = 1:n;


A=load('inputImage.txt');
figure(1); clf; imagesc(A(R, C)); colorbar; title('Input image'); colormap(gray)

A=load('albedoImage.txt');
figure(2); clf; imagesc(A(R, C)); colorbar; title('Albedo image'); colormap(gray)

A=load('sfsUpdate.txt');
figure(3); clf; imagesc(A(R, C)); colorbar; title('Update'); colormap(gray)

A=load('meanDEM.txt');
figure(100); clf; imagesc(A(R, C)); colorbar; title('Mean DEM'); colormap(gray)

A=load('sfsResidual.txt');
figure(4); clf; imagesc(A(R, C)); colorbar; title('Residual'); colormap(gray)

A=load('lhs.txt');
figure(5); clf; imagesc(A(R, C)); colorbar; title('lhs'); colormap(gray)

A=load('sfsDEM0Block.txt');
figure(6); clf; imagesc(A); colorbar; title('DEM block'); colormap(gray)

A=load('inputImageBlock.txt');
figure(7); clf; imagesc(A); colorbar; title('Input image block'); colormap(gray)

M = load('matrix.txt');
figure(8); clf; imagesc(M); colorbar; title('Matrix'); colormap(gray)

% $$$ A8=load('sfsResidual8.txt');
% $$$ figure(1); clf; imagesc(A8); colorbar; title('Block 8'); colormap(gray)
% $$$ 
% $$$ %A16=load('sfsUpdate16.txt');
% $$$ A16=load('sfsResidual16.txt');
% $$$ figure(2); clf; imagesc(A16); colorbar; title('Block 16'); colormap(gray)
% $$$ 
% $$$ figure(3); clf; imagesc(A16-A8); colorbar; title('Diff'); colormap(gray)


%A16=load('sfsUpdate16.txt');
%figure(4); clf; imagesc(A16); colorbar; title('Block 16'); colormap(gray)
%
%A=load('meanDEM.txt');
%figure(2); clf; imagesc(A); colorbar; title('meanDEM'); colormap(gray)
%
%A=load('inputImage.txt');
%figure(3); clf; imagesc(A); colorbar; title('inputImage'); colormap(gray)
%
%A=load('albedoImage.txt');
%figure(1); clf; imagesc(A); colorbar; title('albedoImage'); colormap(gray)

% $$$ 
% $$$ B=load('sfsUpdate16.txt');
% $$$ figure(2); clf; imagesc(B); colorbar; title('Block 16'); colormap(gray)
% $$$ 
%A=load('blocks16.txt');
%figure(6); clf; imagesc(A8./A16); colorbar; title('update ratio'); colormap(gray)
