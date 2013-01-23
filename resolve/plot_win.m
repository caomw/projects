function plot_sigma(s)

   A=load('weight.txt');

X=A(:, 1);
Y=A(:, 2);
Z=A(:, 3);

l = length(Z);
m = sqrt(l);
Z = reshape(Z, m, m);
%figure(1); clf; hold on;
%imagesc(Z);

XX = linspace(min(X), max(X), m);
YY = XX;

W = Z*0;

disp(sprintf('s=%g', s));
for i=1:length(XX)
   for j=1:length(YY)
      x=XX(i);
      y=YY(j);
      W(i, j) = exp(-(x^2+y^2)/s);
   end
end

W = W/sum(sum(W));

figure(2); clf; hold on;
imagesc(W)

%disp(sprintf('Diff is %g', max(max(abs(Z-W)))));
%figure(3); clf; hold on;
%imagesc(Z-W)
%

[m, n] = size(W);
figure(1); clf; hold on; plot(W(:, m/2))

min(min(W))

M = load('adjusted_weights.txt');
figure(3); clf; hold on;
imagesc(M);
title('Window dumped from C++')