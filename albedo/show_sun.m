figure(1); clf; hold on;

A=load('outputAS15.txt');
plot(A(:, 1), A(:, 2), 'b.')
disp(sprintf('Average is %g', mean(A(:, 1))));

A=load('outputAS16.txt');
plot(A(:, 1), A(:, 2), 'r.')
disp(sprintf('Average is %g', mean(A(:, 1))));

A=load('outputAS17.txt');
plot(A(:, 1), A(:, 2), 'g.')
disp(sprintf('Average is %g', mean(A(:, 1))));

