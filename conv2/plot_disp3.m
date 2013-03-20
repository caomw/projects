A=load('bad.txt');
X=A(:, 2); Y=A(:, 3); Z=A(:, 4); W=A(:, 5);

figure(1); clf; hold on;
[m, n] = size(A);
plot(X, Y, 'b.');
plot(Z, W, 'r.');
for i = 1:m
   plot([X(i), Z(i)], [Y(i), W(i)], 'g');
end
axis equal;

A=load('good.txt');
X=A(:, 2); Y=A(:, 3); Z=A(:, 4); W=A(:, 5);

figure(2); clf; hold on;
[m, n] = size(A);
plot(X, Y, 'b.');
plot(Z, W, 'r.');
for i = 1:m
   plot([X(i), Z(i)], [Y(i), W(i)], 'g');
end
axis equal;
