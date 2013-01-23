function z = pctile(H, val)

   for i=1:length(H)
      if sum(H(1:i))/sum(H) >= val
         z = i;
         return;
      end
   end

   