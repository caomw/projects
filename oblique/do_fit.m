function aff = do_fit(type, sub)

   file = sprintf('%s_sub%d.txt', type, sub);
   disp(sprintf('loading file: %s', file));
   A=load(file);

   [m, n] = size(A);
   p0=A(:, 1:2)';
   p1=A(:, 3:4)';

   figure(sub); clf; hold on;
   plot(p0(1, :), p0(2, :), 'b.');
   plot(p1(1, :), p1(2, :), 'r.');
   
   [aff,outliers,robustError] = fit_robust_affine_transform(p1, p0);

