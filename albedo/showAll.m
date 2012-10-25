function showAll(s)
%i=0; %i = 47;

for i=s:s

   disp(sprintf('i=%d', i));
   c = 0.1;
   afile = sprintf('albedo%d.txt', 1000+i);
   A = load(afile);
   figure(1); clf; 
   image(c*A); colorbar; colormap(gray); title('albedo');
   axis ij;

   c = 100;
   wfile = sprintf('weight%d.txt', 1000+i);
   W = load(wfile);
   figure(2); clf; 
   image(c*W); colorbar; colormap(gray); title('weight');
   axis ij;

   c = 100;
   rfile = sprintf('reflectance%d.txt', 1000+i);
   R = load(rfile);
   figure(3); clf; 
   image(c*R); colorbar; colormap(gray); title('reflectance');
   axis ij;

   c = 0.1;
   ifile = sprintf('image%d.txt', 1000+i);
   I = load(ifile);
   figure(4); clf; 
   image(c*I); colorbar; colormap(gray); title('image');
   axis ij;

   disp(sprintf('max %g %g %g', max(max(A)), max(max(W)), max(max(R))));
end