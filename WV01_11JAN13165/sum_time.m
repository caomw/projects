function main()

   do_stats('map.txt');
   do_stats('nomap1.txt');
   do_stats('nomap2.txt');
   do_stats('nomap11.txt');
   do_stats('nomap12.txt');
   
function do_stats(file)

   M = load(file);
   V = M(find(M < 600));
   disp(sprintf('map sum(lt600) avg(lt600) avg(all) %s %g %g, %g', ...
                file, sum(V), mean(V), mean(M)));
   

   