function main()

   lFile1 = 'left.txt';
   lFile2 = 'res_run2_2mpp_subpix21_crop500_500_500_15000/res-L.tif';

   rFile1 = 'right.txt';
   rFile2 = 'res_run2_2mpp_subpix21_crop500_500_500_15000/res-R.tif';

   Zl = do_grid(lFile1, lFile2);
   figure(1); clf; hold on; imagesc(Zl); colormap gray;
   
   Zr = do_grid(rFile1, rFile2);
   figure(2); clf; hold on; imagesc(Zr); colormap gray;

   Zl = im2uint16(Zl/max(max(Zl)));
   disp(sprintf('min and max are %g, %g', min(min(Zl)), max(max(Zl))));
   imwrite(Zl, 'L1.tif');
   
   Zr = im2uint16(Zr/max(max(Zr)));
   disp(sprintf('min and max are %g, %g', min(min(Zr)), max(max(Zr))));
   imwrite(Zr, 'R1.tif');
   
function ZI = do_grid(lFile1, lFile2)
   L = load(lFile1);
   IL=imread(lFile2);
   [p, q] = size(IL);
   disp(sprintf('size is %g %g', p, q));
   
   X = L(:, 1); Y = L(:, 2); Z = L(:, 3);
   I = find(X >= 0 & Y>= 0 & X< p & Y < q);
   X = X(I);
   Y = Y(I);
   Z = Z(I);
   
   disp(sprintf('min and max X is %g %g', min(X), max(X)));
   disp(sprintf('min and max Y is %g %g', min(Y), max(Y)));
   disp(sprintf('min and max Z is %g %g', min(Z), max(Z)));
   
   %figure(1); clf; hold on;
   %plot(X, Y, '.')
   disp(sprintf('sizes are: %g %g', length(X), length(Y)));
   
   [XI, YI] = meshgrid(0:(p-1), 0:(q-1));
   ZI = griddata(X,Y,Z,XI,YI);
   
