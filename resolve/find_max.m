function find_max(X, Y)

   j = 1;
   mx = 0;
   for i=2:(length(Y)-1)
      if Y(i) >= Y(i-1) & Y(i) >= Y(i+1) & Y(i) >= mx
         j=i;
         mx = Y(i);
      end
   end


   disp(sprintf('maximum x and y: %g %g', X(j), Y(j)));
   plot(X(j), Y(j), 'r*')