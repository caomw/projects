fid = fopen('latlon.txt', 'w');
n = 0;
for lon=230:10:300
   for lat=24:58
      fprintf(fid, '%d %d                                                             \r\n', lat, lon);
      n = n+1;
   end
end

disp(sprintf('number of points is %d', n));
fclose(fid)