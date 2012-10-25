%function plot_exposure(file, fig)

A = load('tmp_exposure_calc.txt');
B = load('tmp_exposure_scaled6.txt');
%B = load('output_fix_phase.txt');
%C = load('exposure_1_iter5.txt');
%A = load('exposure_1_iter10.txt');
%C = load('withNorm.txt');

figure(1); clf; hold on;
A = sortrows(A); plot(A(:, 1), A(:, 3), 'b')

%figure(2); clf; hold on;
C=1;
B = sortrows(B); plot(B(:, 1), B(:, 3)/C, 'c')

sum(A(:, 3))/length(A(:, 3))
sum(B(:, 3)/C)/length(B(:, 3))
%
%figure(2); clf; hold on;
%C = sortrows(C); plot(C(:, 1), C(:, 3), 'r')
%B = sortrows(B); plot(B(:, 1), B(:, 3), 'g')
%A = sortrows(A); plot(A(:, 1), A(:, 3), 'b')
