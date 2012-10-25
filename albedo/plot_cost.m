%function plot_cost(file)

figure(3); clf; hold on;

file='output_cost.txt'; A=load(file); plot(A(:, 1), A(:, 2), 'b')
%file='cost_noweights.txt'; A=load(file); plot(A(:, 1), A(:, 2), 'r')
%legend('weights', 'noweights');