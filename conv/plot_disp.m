function plot_disp(file)
   
   A=imread(file);
   size(A)
   min(min(A(:, :, 1))
   max(max(A(:, :, 1))
   
   figure(1);
   subplot(2, 2, 1); imagesc(A(:, :, 1)); colorbar;
   subplot(2, 2, 2); imagesc(A(:, :, 2));
   subplot(2, 2, 3); imagesc(A(:, :, 3));

   