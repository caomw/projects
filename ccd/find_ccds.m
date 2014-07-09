function main(nums)

   ax={};
   ay={};
   for k=0:1
      for i=1:length(nums)
         dir=sprintf('a%d/runva%d_flip%d', nums(i), nums(i), k);
         disp(sprintf('dir is %s', dir));
         ax0=split(ls([dir '*/dx.txt']));
         ay0=split(ls([dir '*/dy.txt']));
         ax = [ax, ax0];
         ay = [ay, ay0];
      end
   end
   
   do_plot(ax, dir, 1);
   title('x');
   
   do_plot(ay, dir, 2); 
   title('y');
   
function do_plot(d, dir, fig)
   
   X = [];
   for i=1:length(d)
      dxf=d{i};
      disp(sprintf('Loading %s', dxf));
      dx = load(dxf);
      X = [X dx];
   end
   X = X';

   [m, n] = size(X);
   disp(sprintf('size is %d %d', m, n));
   
   for r=1:m
      c0 = round(n/3);
      c1 = n - c0;
      cs = 1;
      for c=1:c0
         if X(r, c) == 0
            cs = max(cs, c);
         end
      end

      ce = n;
      for c=(n-c0):n
         if X(r, c) == 0
            ce = min(ce, c);
         end
      end
      
      cs = cs + 300;
      ce = ce - 300;
      for c=1:cs
         X(r, c) = NaN;
      end
      for c=ce:n
         X(r, c) = NaN;
      end
      
   end
   
   wid = 35;

   A = [];
   figure(fig); clf; hold on;
   colors=['b', 'r', 'g', 'c', 'k', 'b', 'r', 'g', 'c', 'b', 'r', 'g', 'k', 'c'];
   q=0;
   s=0.5; % cutoff
   t=0.6; % shift when plotting

   period = 708;
   shift  = -119;
   P1 = period*(2*(1:n))   + shift; I = find(P1 <= n); P1 = P1(I);
   P2 = period*(2*(1:n)+1) + shift; I = find(P2 <= n); P2 = P2(I);

   Z = X(1, :)*0;
   for r=1:m
      q=q+1;
      q = rem(q-1, length(colors)) + 1;
      if r <= length(d) 
         disp(sprintf('doing %s', d{r}));
      end

      Y = X(r, :)-find_moving_avg(X(r, :)); % Y = max(Y, -s); Y = min(Y, s);
      Z = Z + Y;
      X(r, :) = Y;
      plot(Y + t*r, 'b');         
   end

   [m, n] = size(X);
   Z = zeros(1, n);
   for c=1:n
      sum = 0;
      num = 0;
      for r=1:m
         if ~isnan(X(r, c))
            sum = sum + X(r, c);
            num = num + 1;
         end
      end
      if num > 0
         Z(1, c) = sum/num;
      end
   end
   
   plot(Z + t*(m+1), 'r');

   dx0 = Z;
   sx0=find_ccds_aux(dx0);
   I0=1:(length(dx0));
   P0 = sx0(1, :);
   H0 = sx0(2, :);

   P = period*(1:n) + shift;
   I = find(P <= n);
   P = P(I);

   % Keep one CCD per period
   wid = period/7;
   I=[];
   for i=1:length(P)
      J = find( P0 >= P(i) - wid & P0 <= P(i) + wid);
      if length(J) == 0
         continue
      end
      K = find( abs(H0(J)) == max(abs(H0(J))) );
      I = [I, J(K(1))];
   end
   
   P0 = P0(I);
   H0 = H0(I);
%  plot(I0, dx0', 'b');
%  plot(P0, dx0(P0), 'b*');

   plot(P0, H0, 'r');

   format long g
   T = [P0' H0'];
   if fig == 1
      file='ccdx.txt';
   else
      file='ccdy.txt';
   end
   
   disp(sprintf('saving %s', file));
   save(file, '-ascii', '-double', 'T');

function b = split(a)

   % split by space character
   b={};

   c = '';
   for i=1:length(a)
      if isspace(a(i))
         if length(c) ~= 0
            b = [b, c];
            c = '';
         end
      else
         c = [c, a(i)];
      end
   end

   if length(c) ~= 0
      b = [b, c];
   end
   