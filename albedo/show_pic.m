A=load('tmp.txt');
[l, s] = size(A);
   
m = max(A(:, 1));
n = max(A(:, 2));

B = zeros(m, n);

for i=1:l
   B(A(i, 1), A(i, 2)) = A(i, 3);
end

B = max(B, -100);
B = min(B,  100);

imagesc(B');

