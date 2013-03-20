A=load('output1.txt');
X=A(:, 2); Y=A(:, 3); Z=A(:, 4); W=A(:, 5);

[m, n] = size(A);
for i = 1:m
   plot([X(i), Z(i)], [Y(i), W(i)], 'g');
end