function V = find_sep(H)

   V = H*0 + max(H);
   
   c0 = 1; l0 = 1; r0 = 1;
   m = length(H);

   mx = 1e+300;
   
   for c=2:(m-1)

      if ~is_min(c, H); continue; end

      for l=1:(c-1)
         if ~is_max(l, H); continue; end
         
         for r=(c+1):m
            if ~is_max(r, H); continue; end

            v = find_penalty(H, l, c, r);

            if v < V(c)
               V(c) = v;
            end
            
            if v < mx
               mx = v;
               c0 = c; l0 = l; r0 = r;
               disp(sprintf('penalty drops to %g %g', mx, V(c)));
            end
         end
      end
   end

   disp(sprintf('c0, l0, r0, mx is %g %g %g %g %g', c0, l0, r0, mx));
   

function out = is_min(k, H)

   out = 1;
   if k > 1 & H(k-1) < H(k)
      out = 0;
   elseif k < length(H) & H(k+1) < H(k)
      out = 0;
   end


function out = is_max(k, H)

   out = is_min(k, -H);


function v = find_penalty(H, l, c, r)

   v = 0;
   n = length(H);
   for j=1:(l-1)
      v = v - min(H(j+1)-H(j), 0);
   end
   for j=l:(c-1)
      v = v + max(H(j+1)-H(j), 0);
   end
   for j=c:(r-1)
      v = v - min(H(j+1)-H(j), 0);
   end
   for j=r:(n-1)
      v = v + max(H(j+1)-H(j), 0);
   end

   