function plot_ccds(forward, prefix, k)
% Plot ccds with given scan direction with given prefix.
%forward=0; % 1 is fwd, 0 if reverse
%prefix='c';

file = sprintf('scandir_%s.txt', prefix);
disp(sprintf('Loading %s', file));
A=load(file);
[m, n] = size(A);

dirs={};
%for i=1:m
 i = k;
   d=A(i, 1);
   a=A(i, 2);
   b=A(i, 3);

   if a == forward
      dir=sprintf('%s%d/runv%s%d_flip%d', prefix, d, prefix, d, 0);
      dirs=[dirs, dir];
      disp(sprintf('adding %s', dir));
   end

   if b == forward
      dir=sprintf('%s%d/runv%s%d_flip%d', prefix, d, prefix, d, 1);
      dirs=[dirs, dir];
      disp(sprintf('adding %s', dir));
   end
   
%end

   if length(dirs) > 0
      find_ccds(0, dirs)
   end
   

