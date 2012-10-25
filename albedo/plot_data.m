function main()
   
   [X, Y, Z15] = do_parse('tmp15.txt', 1);
   [X, Y, Z16] = do_parse('tmp16.txt', 2);
   [X, Y, Z17] = do_parse('tmp17.txt', 3);
   
   figure(1); clf; imagesc(X, Y, Z15); axis xy; colorbar; title('AS15')
   figure(2); clf; imagesc(X, Y, Z16); axis xy; colorbar; title('AS16')
   figure(3); clf; imagesc(X, Y, Z17); axis xy; colorbar; title('AS17')
   %figure(1); clf; imagesc(X, Y, Z15); axis xy; colorbar; title('AS15')
   %figure(2); clf; imagesc(X, Y, max(Z17, Z16)); axis xy; colorbar; title('AS17')
   %imagesc(sign(4*max(0, Z15)) + 0*sign(max(0, Z16)) + 2*sign(max(0, Z17)));
   
   
   %hold on; colorbar; axis xy;
   
function [X, Y, Z] = do_parse(file, fn)
   
   A=load(file);

   nx = 370;
   ny = 90;
   Z = zeros(nx, ny);
   x0 = -180;
   y0 = -40;
   X = x0 + 1:nx;
   Y = y0 + 1:ny;
   disp(sprintf('miny is %g', min(A(:, 2))));
   
   for k=1:length(A(:, 3))
      x = round(A(k, 1)) - x0;
      y = round(A(k, 2)) - y0;
      z = A(k, 3);
      %disp(sprintf('%d %d', x, X(k)));
      Z(x, y) = z;
   end

%   x = A(:, 1);
%   y = A(:, 2);
%   z = A(:, 3);
%   xlin=linspace(-180,180,100);
%   ylin=linspace(-40,40,100);
%   [X,Y]=meshgrid(xlin,ylin);
%   Z=griddata(x,y,z,X,Y,'cubic');
%   %
%   figure(fn);
%   mesh(X,Y,Z); % interpolated
%   axis tight; hold on;
%   view(0, 90);% colorbar;