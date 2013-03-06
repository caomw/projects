run=1;
N=6;
for i=1:N
   V = levels(i-1, run, 1);
   D1(i) = V(1);
   S1(i) = V(2);
end

run=2;
for i=1:N
   V = levels(i-1, run, 1);
   D2(i) = V(1);
   S2(i) = V(2);
end

%H = figure(5); set(H, 'Position', [900 600 300 300]); clf; hold on;
%H = figure(7); set(H, 'Position', [600 200 300 300]); clf; hold on; title('thresh 0.005')
H = figure(8); set(H, 'Position', [300 200 300 300]); clf; hold on; title('no thresh')
X=0:(N-1);
plot(X, D1, 'b'); 
plot(X, D2, 'r');
legend('run1', 'run2');

H = figure(9); set(H, 'Position', [000 200 300 300]); clf; hold on;
%H = figure(6); set(H, 'Position', [900 200 300 300]); clf; hold on;
plot(X, S1, 'b');
plot(X, S2, 'r');
legend('run1', 'run2');
title('sobel with thresh')

