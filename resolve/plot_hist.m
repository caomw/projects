figure(1); clf; hold on;

M = load('results_1mpp_M139939938LE_M139946735RE/res-DEMError_dat.txt');

m=1;
subplot(3, 1, m);
A = M(m, :);
plot(A); title('lon'); 
axis([-5, length(A)+5, 0, 1.2*max(A)])

m=2;
subplot(3, 1, m);
A = M(m, :);
plot(A); title('lat'); 
axis([-5, length(A)+5, 0, 1.2*max(A)])

m=3;
subplot(3, 1, m);
A = M(m, :);
plot(A); title('height'); 
axis([-5, length(A)+5, 0, 1.2*max(A)])

saveas(gcf, 'hist.png')