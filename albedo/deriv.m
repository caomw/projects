doOverlap = 0;

A=load('update1Block.txt');
figure(4); clf; imagesc(A); colorbar; title('update'); colormap(gray)

if ~doOverlap
   E0=load('error0.txt');
   E=load('error.txt');
   J=load('jacobian0.txt');
else
   E0=load('errorOverlap0.txt');
   E=load('errorOverlap.txt');
   J=load('jacobianOverlap0.txt');
end

A=load('albedoImageBlock.txt');
figure(1); clf; imagesc(A); colorbar; title('Albedo'); colormap(gray)

A=load('inputImageBlock.txt');
figure(5); clf; imagesc(A); colorbar; title('Input image'); colormap(gray)

figure(6); clf; imagesc(E0); colorbar; title('Error'); colormap(gray)

data = load('eps.txt');

ep = data(1);
l = data(2);
k = data(3);
b = data(4);

for ls=-2:2
   for ks=-2:2
      if l + ls >= 0 & k + ks >= 0
         %disp(sprintf('Diff at l=%d k=%d is %g', ...
         %             l + ls, k + ks, E(k + 1 + ks, l + 1 + ls) - E0(k + 1 + ks, l + 1 + ls)));
      end
   end
end

disp(sprintf('l and k are: %d %d', l, k));

disp(sprintf('eps is %0.10g', ep));

[p, q] = size(J);
disp(sprintf('Size of J is %d %d', p, q));

r = k*(b+1) + l + 1; c = k*b + l + 1; J00 = J(r, c); diff = -(E(k + 1, l + 1) - E0(k + 1, l + 1))/ep;
disp(sprintf('Jacobian at %d %d is %0.10g diff = %0.10g, relErr = %.10g', ...
             r-1, c-1, J00, diff, abs(J00-diff)/abs(J00)));

lp = l + 1;
r = k*(b+1) + lp + 1; c = k*b + l + 1; J10 = J(r, c); diff = -(E(k + 1, lp + 1) - E0(k + 1, lp + 1))/ep;
disp(sprintf('Jacobian at %d %d is %0.10g diff = %0.10g, relErr = %.10g', ...
             r-1, c-1, J10, diff, abs(J10-diff)/abs(J10)));

kp = k + 1;
r = kp*(b+1) + l + 1; c = k*b + l + 1; J01 = J(r, c); diff = -(E(kp + 1, l + 1) - E0(kp + 1, l + 1))/ep;
disp(sprintf('Jacobian at %d %d is %0.10g diff = %0.10g, relErr = %.10g', ...
             r-1, c-1, J01, diff, abs(J01-diff)/abs(J01)));
