D = load('disparity2.txt');

X = D(:, 1);
Y = D(:, 2);
Z = D(:, 3);
W = D(:, 4);

mX = max(X);
mY = max(Y);

P = zeros(mX + 1, mY + 1);

n = length(X);
for i=1:n
   P(X(i)+1, Y(i)+1) = norm([Z(i), W(i)]);
end

figure(1); clf; hold on;
imagesc(P); colorbar;

figure(2); clf; hold on;
quiver(X, Y, Z, W);