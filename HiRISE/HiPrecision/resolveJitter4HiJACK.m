function [ jitterx2, jittery2, realt, minError, linerate, TDI ] = resolveJitter4HiJACK( filepath1, which1, filepath2, which2, filepath3, which3, lineinterval )

   tic
   
   % RESOLVEJITTER4HIJACK is called by createPVLforHiJACK and performs the
% jitter derivation for a HiRISE observation.
%
% Outputs are the jitter in the x (sample) and y (line) directions in
% pixels, realt (ephemeris time at that translation), average error between
% the derived jitter function and the original data, linerate (line time
% read from flat files, used for fuction pixelSmear), TDI (also for
% pixelSmear calculations).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Aaron Boyd and Sarah Mattson for HiROC as part of the 
%   process to describe and correct geometric distortions caused by jitter
%   in HiRISE images. Original version written approximately 6/2008.
%
% CVS ID: $Id: resolveJitter4HiJACK.m,v 1.1 2009/04/15 23:11:20 smattson Exp $
%
% Copyright (C) 2008 Arizona Board of Regents on behalf of the Planetary
% Image Research Laboratory, Lunar and Planetary Laboratory at the
% University of Arizona.
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License, version 2, as
% published by the Free Software Foundation.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tolerance for the error
errortol=.0000000001;
repetitions=50;

%tolerance coefficient for the phase difference
tolcoef=.01;

windowSize = 11;
windowWidth = 2;

% get line rate and TDI from the flat file
data1 = fopen(filepath1, 'r');
disp(sprintf('Will open: %s', filepath1));
TDI = textscan (data1, '%*s %*s %f', 1,'headerlines',13);
linerate = textscan(data1, '%*s %*s %f',1,'headerlines',2);
TDI = TDI{1,1}(1);
linerate = linerate{1,1}(1);

% $$$ TDI
% $$$ linerate

%get the data from the file
textdata1 = fopen(filepath1, 'r');
imageLength = textscan(textdata1, '%*s %*s %f',1,'headerlines',6);
%imageLength

data1 = textscan(textdata1, '%f64 %f64 %f64 %f64 %f64 %f64 %f %f %*f %*f %*f %*f','headerlines', 49);
fclose('all');
imageLength = imageLength{1,1}(1);

%for improved speed use powers of 2 in fourier transform
% dividing by the line interval used in hijitreg
%imageLength(1,1)/ lineinterval
nfft=2^(nextpow2(imageLength(1,1)/ lineinterval));
%nfft

%data1{1,1}

%put the data into usable variables
if which1==1
    column=4;
else
    column=1;
end
dt1=which1*(data1{1,1}(1)-data1{1,4}(1));
t1=data1{1,column}(:,1);
t01=t1(1);

offx1=which1*(data1{1,7}(:,1)-data1{1,2}(:,1));
offy1=which1*(data1{1,8}(:,1)-data1{1,3}(:,1));

% $$$ size(dt1)
% $$$ size(offx1)

% $$$ disp(sprintf('dt1 = %0.20g', dt1));


%size(offy1)
%size(data1{1,1})
%t01

duration1=t1(end)-t01;
%duration1



%filtering out the bad points
magnitude1=(offx1.^2+offy1.^2).^(1/2);
avemag1= medfilt1(magnitude1,windowSize);

%avemagx = fastmedfilt1d(magnitude1,windowSize);
% $$$ max(abs(avemag1 - avemagx)) 
% $$$ return

upper1=magnitude1-windowWidth-avemag1;
lower1=magnitude1+windowWidth-avemag1;
tooHigh1 = find(upper1>0);
tooLow1 = find(lower1<0);
outofRange1=[tooHigh1; tooLow1];

% $$$ size(tooHigh1)
% $$$ size(tooLow1)
% $$$ size(outofRange1)
% $$$ size(t1)
%return 

%for the color images with multiple lines in each.
a=1;
ttt=t1(a);
x(a)=offx1(a);
y(a)=offy1(a);
repeat=1;

for n=2:length(t1),
   testing = isempty(find(outofRange1==n,1));

    if testing
        if t1(n)==t1(n-1),
            repeat=repeat+1;
            x(a)=offx1(n)+x(a);
            y(a)=offy1(n)+y(a);
            ttt(a)=t1(n);
        else
            x(a)=x(a)/repeat;
            y(a)=y(a)/repeat;

            repeat=1;
            a=a+1;

            ttt(a)=t1(n);
            x(a)=offx1(n);
            y(a)=offy1(n);
        end
    end
end

x(end)=x(end)/repeat;
y(end)=y(end)/repeat;
t1=ttt;

% $$$ for n=1:length(x)
% $$$     %disp(sprintf('%0.18g %0.18g %0.18g', x(n), y(n), t1(n)));
% $$$ end

%disp(sprintf('size of x, y, t1 is %d %d %d', length(x), length(y), length(t1)));

offx1=x;
offy1=y;
%plotting the original offsets
% figure(200)
% subplot(2,1,1),hold off, plot(offx1,'r'), subplot(2,1,2),hold off, plot(offy1,'r')

%smoothing the offsets to reduce noise
%sets up padding so the data is not distorted
frontPadding=floor((nfft-a/2));
backPadding=ceil((nfft-a/2));

%disp(sprintf('front and back padding %d %d', frontPadding, backPadding));

%filters the data
offx1=ifft(fft([ones(1,frontPadding)*x(1), x, ones(1,backPadding)*x(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
offx1=offx1((frontPadding+1):(frontPadding+a));

offy1=ifft(fft([ones(1,frontPadding)*y(1), y,ones(1,backPadding)*y(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
offy1=offy1((frontPadding+1):(frontPadding+a));


% $$$ B=load('out.txt');
% $$$ size(offy1)
% $$$ size(B)
% $$$ max(abs(B-offy1'))
% $$$ return

%A=exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2);
%B=load('out.txt');
%size(A)
%size(B)
%%A-B'
%max(max(abs(A-B')))
%fft([ones(1,frontPadding)*x(1), x, ones(1,backPadding)*x(a)],nfft*2)
%fft([ones(1,frontPadding)*x(1), x, ones(1,backPadding)*x(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2)

%plotting the smoothed offsets
% figure(200)
% subplot(2,1,1),hold on, plot(offx1), subplot(2,1,2),hold on, plot(offy1)

%Ax = [ones(1,frontPadding)*x(1), x, ones(1,backPadding)*x(a)];
%disp(sprintf('sizes: %d, %d', length(Ax), 2*nfft));
%Ay = [ones(1,frontPadding)*y(1), y, ones(1,backPadding)*y(a)];
%B = [Ax' Ay'];
%C=load('out.txt');
%size(B)
%size(C)
%max(abs(C-B))

%A = fft([ones(1,frontPadding)*x(1), x,ones(1,backPadding)*x(a)],nfft*2);
%A(end)

%return

%clear the variables no longer used to decrease memory comsumption
clear a x y ttt repeat frontPadding backPadding n column;















%for the second Image
%get the data from the file
textdata2 = fopen(filepath2, 'r');
data2 = textscan(textdata2, '%f64 %f64 %f64 %f64 %f64 %f64 %f %f %*f %*f %*f %*f','headerlines', 55);
fclose('all');


%put the data into usable variables
if which2==1
    column=4;
else
    column=1;
end
dt2=which2*(data2{1,1}(1)-data2{1,4}(1));
t2=data2{1,column}(:,1);
t02=t2(1);

offx2=which2*(data2{1,7}(:,1)-data2{1,2}(:,1));
offy2=which2*(data2{1,8}(:,1)-data2{1,3}(:,1));

% $$$ A=load('out.txt');
% $$$ size(offx2)
% $$$ size(A')
% $$$ max(abs(offx2 - A))
% $$$ 
% $$$ return

%duration2=t2(end)-t02;




%filtering out the bad points
windowSize = 11;
% $$$ windowWidth = 2;
magnitude2=(offx2.^2+offy2.^2).^(1/2);

avemag2= medfilt1(magnitude2,windowSize);

% $$$ A=load('out.txt');
% $$$ size(t2)
% $$$ size(A)
% $$$ max(abs(avemag2 - A))
% $$$ return

% $$$ windowWidth
% $$$ return

upper2=magnitude2-windowWidth-avemag2;
lower2=magnitude2+windowWidth-avemag2;
tooHigh2 = find(upper2>0);
tooLow2 = find(lower2<0);
outofRange2=[tooHigh2; tooLow2];

% $$$ windowWidth
% $$$ for row=1:length(avemag1)
% $$$    if (magnitude2(row) - windowWidth - avemag2(row) > 0 | ...
% $$$       magnitude2(row) + windowWidth - avemag2(row) < 0 )
% $$$       row
% $$$    end
% $$$ end

% $$$ %outofRange2
% $$$ return

%for the color images with multiple lines in each.
a=1;
ttt=t2(a);
x(a)=offx2(a);
y(a)=offy2(a);
repeat=1;
for n=2:length(t2),
    testing = isempty(find(outofRange2==n,1));
    if testing
        if t2(n)==t2(n-1),
            repeat=repeat+1;
            x(a)=offx2(n)+x(a);
            y(a)=offy2(n)+y(a);
            ttt(a)=t2(n);
        else
            x(a)=x(a)/repeat;
            y(a)=y(a)/repeat;

            repeat=1;
            a=a+1;

            ttt(a)=t2(n);
            x(a)=offx2(n);
            y(a)=offy2(n);
        end
    end
end
x(end)=x(end)/repeat;
y(end)=y(end)/repeat;
t2=ttt;

offx2=x;
offy2=y;

% $$$ disp(sprintf('Num rows is %d', length(x)));
% $$$ return

% $$$ A=load('out.txt');
% $$$ size(offx2)
% $$$ size(A')
% $$$ max(abs(offx2 - A))
% $$$ return

%plotting original offsets
% figure(201)
% subplot(2,1,1),hold off, plot(offx2,'r'), subplot(2,1,2),hold off, plot(offy2,'r')

%smoothing the offsets to reduce noise
%sets up padding so the data is not distorted
frontPadding=floor((nfft-a/2));
backPadding=ceil((nfft-a/2));

%filters the data
offx2=ifft(fft([ones(1,frontPadding)*x(1), x,ones(1,backPadding)*x(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
offx2=offx2((frontPadding+1):(frontPadding+a));
offy2=ifft(fft([ones(1,frontPadding)*y(1), y,ones(1,backPadding)*y(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
offy2=offy2((frontPadding+1):(frontPadding+a));

%plotting smoothed offsets
% figure(201)
% subplot(2,1,1),hold on, plot(offx2), subplot(2,1,2),hold on, plot(offy2)
clear a x y ttt repeat frontPadding backPadding n column;


















%for the third Image
%get the data from the file
textdata3 = fopen(filepath3, 'r');
data3 = textscan(textdata3, '%f64 %f64 %f64 %f64 %f64 %f64 %f %f %*f %*f %*f %*f','headerlines', 55);
fclose('all');


%put the data into usable variables
if which3==1
    column=4;
else
    column=1;
end
dt3=which3*(data3{1,1}(1)-data3{1,4}(1));
t3=data3{1,column}(:,1);
t03=t3(1);

offx3=which3*(data3{1,7}(:,1)-data3{1,2}(:,1));
offy3=which3*(data3{1,8}(:,1)-data3{1,3}(:,1));

%duration3=t3(end)-t03;

%filtering out the bad points
windowSize = 11;
%windowWidth = 2;
magnitude3=(offx3.^2+offy3.^2).^(1/2);
avemag3= medfilt1(magnitude3,windowSize);
upper3=magnitude3-windowWidth-avemag3;
lower3=magnitude3+windowWidth-avemag3;
tooHigh3 = find(upper3>0);
tooLow3 = find(lower3<0);
outofRange3=[tooHigh3; tooLow3];

% $$$ sort(outofRange3)

%for the color images with multiple lines in each.
a=1;
ttt=t3(a);
x(a)=offx3(a);
y(a)=offy3(a);
repeat=1;
for n=3:length(t3), % bug here!!! temporary!!!
    testing = isempty(find(outofRange3==n,1));
    if testing
        if t3(n)==t3(n-1),
            repeat=repeat+1;
            x(a)=offx3(n)+x(a);
            y(a)=offy3(n)+y(a);
            ttt(a)=t3(n);
        else
            x(a)=x(a)/repeat;
            y(a)=y(a)/repeat;

            repeat=1;
            a=a+1;

            ttt(a)=t3(n);
            x(a)=offx3(n);
            y(a)=offy3(n);
        end
    end
end
x(end)=x(end)/repeat;
y(end)=y(end)/repeat;
t3=ttt;

offx3=x;
offy3=y;




%plotting original offsets
% figure(202)
% subplot(2,1,1),hold off, plot(offx3,'r'), subplot(2,1,2),hold off, plot(offy3,'r')

%smoothing the offsets to reduce noise
%sets up padding so the data is not distorted
frontPadding=floor((nfft-a/2));
backPadding=ceil((nfft-a/2));

%filters the data
offx3=ifft(fft([ones(1,frontPadding)*x(1), x,ones(1,backPadding)*x(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
offx3=offx3((frontPadding+1):(frontPadding+a));
offy3=ifft(fft([ones(1,frontPadding)*y(1), y,ones(1,backPadding)*y(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
offy3=offy3((frontPadding+1):(frontPadding+a));

%A=load('out.txt');
%size(A)
%size(offy3)
%max(abs(offy3 - A'))
%return

%plotting smoothed offsets
% figure(202)
% subplot(2,1,1),hold on, plot(offx3), subplot(2,1,2),hold on, plot(offy3)

%clear the variables no longer used to decrease memory comsumption
clear testing n a x y ttt repeat frontPadding backPadding tooLow* toohigh*;
clear outofRange* magnitude* avemag* upper* lower* windowSize windowWidth ;
clear repeat imageLength data* textdata* column;

















%the start and end time of the image
start=1;
finish=nfft;

%making time regularly spaced
tt=(0:(nfft-1))/(nfft);
realt1=(0:(nfft-1))/(nfft-1)*duration1+t01;
%realt2=(0:(nfft-1))/(nfft-1)*duration1+t02;
%realt3=(0:(nfft-1))/(nfft-1)*duration1+t03;

%max(abs(realt1 - realt2))
%max(abs(realt1 - realt3))
%
%return
% 

xinterp1=interp1(t1-t01,offx1,realt1-t01,'pchip',mean(offx1));
yinterp1=interp1(t1-t01,offy1,realt1-t01,'pchip',mean(offy1));

% $$$ 
% $$$ %[realt1'-t01 xinterp1']
% $$$ A=load('out.txt');
% $$$ T=A(:, 1);
% $$$ X=A(:, 2);
% $$$ size(T)
% $$$ max(abs(realt1'-t01 - T))
% $$$ max(abs(yinterp1' - X))
% $$$ return


xinterp2=interp1(t2-t01,offx2,realt1-t01,'pchip',mean(offx2));
yinterp2=interp1(t2-t01,offy2,realt1-t01,'pchip',mean(offy2));

xinterp3=interp1(t3-t01,offx3,realt1-t01,'pchip',mean(offx3));
yinterp3=interp1(t3-t01,offy3,realt1-t01,'pchip',mean(offy3));

%[t3(1) - t01, t3(end) - t01]
%[realt1(1) - t01, realt1(end) - t01]

%xinterp3
%
%return

%A=load('out.txt');
%size(xinterp3)
%size(A)
%max(abs(xinterp3 - A'))
%R=xinterp3 - A';
%[A(1:50) xinterp3(1:50)']
%R(1:50)
%return





%getting the frequencies of the Fourier transform
freq = linspace(0,nfft/2-1,nfft/2);

%preallocating loops
overx=zeros(repetitions,nfft);
overy=overx;



%taking the fourier transform of the offsets
X1=2*fft(xinterp1,nfft)/nfft;
Y1=2*(fft(yinterp1,nfft))/nfft;

X2=2*fft(xinterp2,nfft)/nfft;
Y2=2*(fft(yinterp2,nfft))/nfft;

X3=2*fft(xinterp3,nfft)/nfft;
Y3=2*(fft(yinterp3,nfft))/nfft;

%seperating sines and cosines
X1A=real(X1(1:(nfft/2)));
X1B=-imag(X1(1:(nfft/2)));

Y1A=real(Y1(1:(nfft/2)));
Y1B=-imag(Y1(1:(nfft/2)));

%for the second image
X2A=real(X2(1:(nfft/2)));
X2B=-imag(X2(1:(nfft/2)));

Y2A=real(Y2(1:(nfft/2)));
Y2B=-imag(Y2(1:(nfft/2)));

%for the third image
X3A=real(X3(1:(nfft/2)));
X3B=-imag(X3(1:(nfft/2)));

Y3A=real(Y3(1:(nfft/2)));
Y3B=-imag(Y3(1:(nfft/2)));


%calculates the phase difference
ddt1=mod(dt1/duration1*2*pi.*freq,2*pi);
ddt2=mod(dt2/duration1*2*pi.*freq,2*pi);
ddt3=mod(dt3/duration1*2*pi.*freq,2*pi);


%A=load('out.txt');
%max(abs(real(Y3B) - A'))
%return
%


%creates a matrix for times and frequncies
timesfreq=2*pi*freq'*tt;

%this is the coeficients for the frequencies
aaax1=diag(-1/2*(-X1A.*cos(ddt1)+sin(ddt1).*X1B-X1A)./sin(ddt1));
aaay1=diag(-1/2*(-Y1A.*cos(ddt1)+sin(ddt1).*Y1B-Y1A)./sin(ddt1));

bbbx1=diag(-1/2*( X1B.*cos(ddt1)+sin(ddt1).*X1A+X1B)./sin(ddt1));
bbby1=diag(-1/2*( Y1B.*cos(ddt1)+sin(ddt1).*Y1A+Y1B)./sin(ddt1));

%
%size(freq)
%size(tt)
%%size(timesfreq)
%L = -1/2*(-X1A.*cos(ddt1)+sin(ddt1).*X1B-X1A)./sin(ddt1);
%A=load('out.txt');
%max(max(abs(L - A')))
%
%size(L)
%size(aaax1)
%%return
%return
%aaax1(1:10)
% $$$ Q=-1/2*(-X1A.*cos(ddt1)+sin(ddt1).*X1B-X1A)./sin(ddt1);
% $$$ Q(1:10)

clear X1A X1B Y1A Y1B

%create series of sines and cosines
overxx1=aaax1*sin(timesfreq)+bbbx1*cos(timesfreq);
overyy1=aaay1*sin(timesfreq)+bbby1*cos(timesfreq);

% $$$ return
% $$$ 
% $$$ A=load('out.txt');
% $$$ max(max(abs(A-overyy1)))
% $$$ return

clear aaax1 aaay1 bbbx1 bbby1

aaax2=diag(-1/2*(-X2A.*cos(ddt2)+sin(ddt2).*X2B-X2A)./sin(ddt2));
aaay2=diag(-1/2*(-Y2A.*cos(ddt2)+sin(ddt2).*Y2B-Y2A)./sin(ddt2));

bbbx2=diag(-1/2*( X2B.*cos(ddt2)+sin(ddt2).*X2A+X2B)./sin(ddt2));
bbby2=diag(-1/2*( Y2B.*cos(ddt2)+sin(ddt2).*Y2A+Y2B)./sin(ddt2));
clear X2A X2B Y2A Y2B

overxx2=aaax2*sin(timesfreq)+bbbx2*cos(timesfreq);
overyy2=aaay2*sin(timesfreq)+bbby2*cos(timesfreq);

clear aaax2 aaay2 bbbx2 bbby2





aaax3=diag(-1/2*(-X3A.*cos(ddt3)+sin(ddt3).*X3B-X3A)./sin(ddt3));
aaay3=diag(-1/2*(-Y3A.*cos(ddt3)+sin(ddt3).*Y3B-Y3A)./sin(ddt3));

bbbx3=diag(-1/2*( X3B.*cos(ddt3)+sin(ddt3).*X3A+X3B)./sin(ddt3));
bbby3=diag(-1/2*( Y3B.*cos(ddt3)+sin(ddt3).*Y3A+Y3B)./sin(ddt3));
clear X3A X3B Y3A Y3B


overxx3=aaax3*sin(timesfreq)+bbbx3*cos(timesfreq); % 1024 x 2048 matrix
overyy3=aaay3*sin(timesfreq)+bbby3*cos(timesfreq);

clear aaax3 aaay3 bbbx3 bbby3 timesfreq

















%starting a loop to find correct phase tol
k=0;
aveerror=errortol;

while aveerror>=errortol && k<repetitions

    k=k+1;
    %setting the phase tolerance
    phasetol = (k)*tolcoef;

    %null the frequencies that cause a problem
    nullindex1=abs(ddt1)<phasetol | (2*pi-abs(ddt1))< phasetol;
% $$$     nullindex1
% $$$     find(nullindex1 ~= 0)
% $$$     return
    nullindex2=abs(ddt2)<phasetol | (2*pi-abs(ddt2))< phasetol;
    nullindex3=abs(ddt3)<phasetol | (2*pi-abs(ddt3))< phasetol;

    overxxx1=overxx1; overyyy1=overyy1;
    overxxx1(nullindex1,:)=0; overyyy1(nullindex1,:)=0;

    overxxx2=overxx2; overyyy2=overyy2;
    overxxx2(nullindex2,:)=0; overyyy2(nullindex2,:)=0;

    overxxx3=overxx3; overyyy3=overyy3;
    overxxx3(nullindex3,:)=0; overyyy3(nullindex3,:)=0;

%    B=load('out.txt');
%    max(max(abs(overxxx1 - B)))
%    return
% $$$     %nullindex1
% $$$     zeros(1, 5)
% $$$     overxxx2(nullindex1,1:5)
% $$$     isequal(zeros(1,5),overxxx2(nullindex1,1:5))
    
    %return
    
% $$$     ~isequal(zeros(1,5),overxxx2(nullindex1,1:5))
% $$$     ~isequal(zeros(1:5),overxxx3(nullindex1,1:5))
% $$$     overxxx3(nullindex1,1:5)
    %overxxx3(121, 1)
    
% $$$     (~isequal(zeros(1,5),overxxx1(nullindex2,1:5))+~isequal(zeros(1:5),overxxx3(nullindex2,1:5)))
% $$$     (~isequal(zeros(1,5),overxxx2(nullindex3,1:5))+~isequal(zeros(1:5),overxxx1(nullindex3,1:5)))    
% $$$     (~isequal(zeros(1,5),overyyy2(nullindex1,1:5))+~isequal(zeros(1:5),overyyy3(nullindex1,1:5)))
% $$$     (~isequal(zeros(1,5),overyyy1(nullindex2,1:5))+~isequal(zeros(1:5),overyyy3(nullindex2,1:5)))
% $$$     (~isequal(zeros(1,5),overyyy2(nullindex3,1:5))+~isequal(zeros(1:5),overyyy1(nullindex3,1:5)))
%return

%    B=load('out.txt');
%    disp(sprintf('max error good %g', max(max(abs(B - overxxx2)))));
%    return;
    %tmp = overyyy3;
    
    %finding which ones are zero
    overxxx1(nullindex1,:)=(overxxx2(nullindex1,:)+overxxx3(nullindex1,:))/(~isequal(zeros(1,5),overxxx2(nullindex1,1:5))+~isequal(zeros(1:5),overxxx3(nullindex1,1:5)));
    % inconsistency below!!!
    overxxx2(nullindex2,:)=(overxxx2(nullindex2,:)+overxxx3(nullindex2,:))/(~isequal(zeros(1,5),overxxx1(nullindex2,1:5))+~isequal(zeros(1:5),overxxx3(nullindex2,1:5)));
    overxxx3(nullindex3,:)=(overxxx2(nullindex3,:)+overxxx1(nullindex3,:))/(~isequal(zeros(1,5),overxxx2(nullindex3,1:5))+~isequal(zeros(1:5),overxxx1(nullindex3,1:5)));

    overyyy1(nullindex1,:)=(overyyy2(nullindex1,:)+overyyy3(nullindex1,:))/(~isequal(zeros(1,5),overyyy2(nullindex1,1:5))+~isequal(zeros(1:5),overyyy3(nullindex1,1:5)));
    overyyy2(nullindex2,:)=(overyyy2(nullindex2,:)+overyyy3(nullindex2,:))/(~isequal(zeros(1,5),overyyy1(nullindex2,1:5))+~isequal(zeros(1:5),overyyy3(nullindex2,1:5)));
    overyyy3(nullindex3,:)=(overyyy2(nullindex3,:)+overyyy1(nullindex3,:))/(~isequal(zeros(1,5),overyyy2(nullindex3,1:5))+~isequal(zeros(1:5),overyyy1(nullindex3,1:5)));


    %adding all frequencies together
    overxxx=(overxxx1+overxxx2+overxxx3)/3;
    overxxx(isnan(overxxx(:,1)),:)=0;
    overyyy=(overyyy1+overyyy2+overyyy3)/3;
    overyyy(isnan(overyyy(:,1)),:)=0;

    overx(k,:)=sum(overxxx,1);
    overy(k,:)=sum(overyyy,1);
    %disp(sprintf('xxxx---------------xxx'));
    
    jitterx=overx(k,:)-overx(k,1);
    jittery=overy(k,:)-overy(k,1);

%    B=load('out.txt');
%    disp(sprintf('---------------max error good %g', max(max(abs(jittery - B')))));
%    return
%
%    size(interp1(tt(start:finish),jitterx,tt(start:finish)+dt1/duration1))
%    size(jitterx)
%    size(tt)
%    size(tt(start:finish))
%    return
    
    %checking
    
    jittercheckx1=interp1(tt(start:finish),jitterx,tt(start:finish)+dt1/duration1)-jitterx;
    jitterchecky1=interp1(tt(start:finish),jittery,tt(start:finish)+dt1/duration1)-jittery;

    jittercheckx2=interp1(tt(start:finish),jitterx,tt(start:finish)+dt2/duration1)-jitterx;
    jitterchecky2=interp1(tt(start:finish),jittery,tt(start:finish)+dt2/duration1)-jittery;
   
    jittercheckx3=interp1(tt(start:finish),jitterx,tt(start:finish)+dt3/duration1)-jitterx;
    jitterchecky3=interp1(tt(start:finish),jittery,tt(start:finish)+dt3/duration1)-jittery;

    %eliminate NaNs
    jittercheckx1(isnan(jittercheckx1))=0;
    jitterchecky1(isnan(jitterchecky1))=0;
    
    jittercheckx2(isnan(jittercheckx2))=0;
    jitterchecky2(isnan(jitterchecky2))=0;
    
    jittercheckx3(isnan(jittercheckx3))=0;
    jitterchecky3(isnan(jitterchecky3))=0;

    % inconsistency in the error
    aveerror=mean(1/6*(abs(xinterp1 -(jittercheckx1 + X1(1) / 2))+ abs(xinterp2 - (jittercheckx2 +X2(1)))+abs(xinterp3 -(jittercheckx3+X3(1)))+abs(yinterp1-(jitterchecky1 + Y1(1) / 2))+abs(yinterp2-(jitterchecky2 + Y2(1) / 2))+abs(yinterp3-(jitterchecky3 + Y3(1) / 2))));
    %    return;
    
    disp(sprintf('1: aveerror = %0.20g', aveerror));
    
    errors(k)=aveerror;
    
%    B=load('out.txt');
%%    disp(sprintf('\n\n---------------max error good %g\n\n', max(max(abs(B - jittercheckx1')))));
%    T = [jittercheckx1' jitterchecky1' jittercheckx2' jitterchecky2' jittercheckx3' jitterchecky3'];
%    size(B)
%    size(T)
%    disp(sprintf('err is %g', max(max(abs(B-T)))));
%    return
    
%    A = tt(start:finish);
%    B = jitterx;
%    C = tt(start:finish)+dt1/duration1;
%    D = interp1(tt(start:finish),jitterx,tt(start:finish)+
%    p = 60; [A(1:p)' B(1:p)' C(1:p)' D(1:p)']
%    
    %    return
    
    
    
    %disp(sprintf('----------------temporary!!!!'));
    %break

    
end

%saving the min error for the phase difference
minerror=min(errors);
minindex=find(errors==minerror,1,'first');

    jitterx=overx(minindex,:)-overx(minindex,1);
    jittery=overy(minindex,:)-overy(minindex,1);

    
    %checking
    jittercheckx1=interp1(tt(start:finish),jitterx,tt(start:finish)+dt1/duration1)-jitterx;
    jitterchecky1=interp1(tt(start:finish),jittery,tt(start:finish)+dt1/duration1)-jittery;
    
    jittercheckx2=interp1(tt(start:finish),jitterx,tt(start:finish)+dt2/duration1)-jitterx;
    jitterchecky2=interp1(tt(start:finish),jittery,tt(start:finish)+dt2/duration1)-jittery;
    
    jittercheckx3=interp1(tt(start:finish),jitterx,tt(start:finish)+dt3/duration1)-jitterx;
    jitterchecky3=interp1(tt(start:finish),jittery,tt(start:finish)+dt3/duration1)-jittery;



    %eliminate NaNs
    jittercheckx1(isnan(jittercheckx1))=0;
    jitterchecky1(isnan(jitterchecky1))=0;
    
    jittercheckx2(isnan(jittercheckx2))=0;
    jitterchecky2(isnan(jitterchecky2))=0;
    
    jittercheckx3(isnan(jittercheckx3))=0;
    jitterchecky3(isnan(jitterchecky3))=0;

    

%     %plotting
%     k=minindex;
%     tplot=t01;
%     figure(k)
%     clf
%     subplot(2,2,1), hold on, plot(t1-tplot,offx1,'.r'), plot(realt1-tplot,xinterp1,'g'),
%     plot(realt1-tplot,jittercheckx1+X1(1)/2,'y'),hold off
%     subplot(2,2,2), hold on, plot(t1-tplot,offy1,'.r'), plot(realt1-tplot,yinterp1,'g'),
%     plot( realt1-tplot, jitterchecky1 + Y1(1) / 2,'y'),hold off
%     subplot(2,2,3), hold on, plot(realt1 - tplot , jitterx) , hold off
%     subplot(2,2,4), hold on, plot(realt1 - tplot , jittery) , hold off
%     figure(k+100)
%     tplot=t01;
%     clf
%     subplot(2,2,1), hold on, plot(t2-t02,offx2,'.r'), plot(realt1-tplot,xinterp2,'g'),
%     plot(realt1-tplot,jittercheckx2+X2(1)/2,'y'),hold off
%     subplot(2,2,2), hold on, plot(t2-t02,offy2,'.r'), plot(realt1-tplot,yinterp2,'g'),
%     plot( realt1-tplot, jitterchecky2 + Y2(1) / 2,'y'),hold off
%     subplot(2,2,3), hold on, plot(realt1 - tplot , jitterx) , hold off
%     subplot(2,2,4), hold on, plot(realt1 - tplot , jittery) , hold off
%     figure(k+200)
%     tplot=t01;
%     clf
%     subplot(2,2,1), hold on, plot(t3-t03,offx3,'.r'), plot(realt1-tplot,xinterp3,'g'),
%     plot(realt1-tplot,jittercheckx3+X3(1)/2,'y'),hold off
%     subplot(2,2,2), hold on, plot(t3-t03,offy3,'.r'), plot(realt1-tplot,yinterp3,'g'),
%     plot( realt1-tplot, jitterchecky3 + Y3(1) / 2,'y'),hold off
%     subplot(2,2,3), hold on, plot(realt1 - tplot , jitterx) , hold off
%     subplot(2,2,4), hold on, plot(realt1 - tplot , jittery) , hold off
    clear jittercheckx1 jittercheckx2 jittercheckx3 
    clear jitterchecky1 jitterchecky2 jitterchecky3
    clear overx overy errors minerror aveerror


    
    


















    disp(sprintf('-------------------------------------'));





%starting a loop to find the correct filter size
k=0;
aveerror=errortol;
jitterxx=zeros(repetitions,nfft);
jitteryy=jitterxx;

%B=load('out.txt');
%T = [jitterx' jittery'];
%disp(sprintf('\n\n---------------max error2 %g\n\n', max(max(abs(B - T)))));
%return;
%
%return


while aveerror>=errortol && k<repetitions
    k=k+1;

    %make the filter
    omega=(k-1);
    filtertest = exp(-(omega/(2*nfft)*[0:(nfft-1) -(nfft):-1]).^2);


    jitterxs=ifft(fft([ones(1,nfft/2)*jitterx(1) jitterx ones(1,nfft/2)*jitterx(end)],nfft*2).*filtertest,nfft*2,'symmetric');
    jitterxx(k,:)=jitterxs(1,((nfft/2+1):(nfft*3/2)));
    
    jitterys=ifft(fft([ones(1,nfft/2)*jittery(1) jittery(1,:) ones(1,nfft/2)*jittery(end)],nfft*2).*filtertest,nfft*2,'symmetric');
    jitteryy(k,:)=jitterys(1,((nfft/2+1):(nfft*3/2)));
    
    jitterxx(k,:)=jitterxx(k,:)-jitterxx(k,1);
    jitteryy(k,:)=jitteryy(k,:)-jitteryy(k,1);

    clear jitterxs jitterys
    

%checking
    jittercheckx1=interp1(tt(start:finish),jitterxx(k,:),tt(start:finish)+dt1/duration1)-jitterxx(k,:);
    jitterchecky1=interp1(tt(start:finish),jitteryy(k,:),tt(start:finish)+dt1/duration1)-jitteryy(k,:);
    
    jittercheckx2=interp1(tt(start:finish),jitterxx(k,:),tt(start:finish)+dt2/duration1)-jitterxx(k,:);
    jitterchecky2=interp1(tt(start:finish),jitteryy(k,:),tt(start:finish)+dt2/duration1)-jitteryy(k,:);
    
    jittercheckx3=interp1(tt(start:finish),jitterxx(k,:),tt(start:finish)+dt3/duration1)-jitterxx(k,:);
    jitterchecky3=interp1(tt(start:finish),jitteryy(k,:),tt(start:finish)+dt3/duration1)-jitteryy(k,:);

    %eliminate NaNs
    nanindex1=isnan(jittercheckx1);
    nanindex2=isnan(jittercheckx2);
    nanindex3=isnan(jittercheckx3);
    
    jittercheckx1(nanindex1)=0;
    jitterchecky1(nanindex1)=0;
    
    jittercheckx2(nanindex2)=0;
    jitterchecky2(nanindex2)=0;
    
    jittercheckx3(nanindex3)=0;
    jitterchecky3(nanindex3)=0;

%    if k == 2
%       disp(sprintf('------------------temporary!!!'));
%       B=load('out.txt');
%       T = [jittercheckx1' jitterchecky1' jittercheckx2' jitterchecky2' jittercheckx3' jitterchecky3'];
%       size(B)
%       size(T)
%       disp(sprintf('err is %g', max(max(abs(B-T)))));
%       %disp(sprintf('\n\n---------------max error5 %g\n\n', max(max(abs(jittercheckx1 - B')))));
%       return;
%    end
    



    tplot=t01;
    %plotting

%    figure(k+300)
%    clf
%    subplot(2,2,1), hold on, plot(t1-tplot,offx1,'.r'), plot(realt1-tplot,xinterp1,'g'),
%    plot(realt1-tplot,jittercheckx1+X1(1)/2,'y'),hold off
%    subplot(2,2,2), hold on, plot(t1-tplot,offy1,'.r'), plot(realt1-tplot,yinterp1,'g'),
%    plot( realt1-tplot, jitterchecky1 + Y1(1) / 2,'y'),hold off
%    subplot(2,2,3), hold on, plot(realt1-tplot,jitterx(k,:)), hold off
%    subplot(2,2,4), hold on, plot(realt1-tplot,jittery(k,:)), hold off
%    pause(0.01);

    % inconsistency in the error!!!
    aveerror=mean(1/6*(abs(xinterp1 -(jittercheckx1 + X1(1) / 2))+ abs(xinterp2 - (jittercheckx2 +X2(1)))+abs(xinterp3 -(jittercheckx3+X3(1)))+abs(yinterp1-(jitterchecky1 + Y1(1) / 2))+abs(yinterp2-(jitterchecky2 + Y2(1) / 2))+abs(yinterp3-(jitterchecky3 + Y3(1) / 2))));
    disp(sprintf('2: aveerror = %0.20g', aveerror));
    errors(k)=aveerror;
end

minerror=min(errors);
minindex=find(errors==minerror,1,'first')

%minindex

minError=errors(minindex);
disp(sprintf('min error is %0.20g at index %d', minError, minindex));
realt=realt1';

jitterx2=jitterxx(minindex,:)';
jittery2=jitteryy(minindex,:)';


%checking
    jittercheckx1=interp1(tt(start:finish),jitterx2,tt(start:finish)+dt1/duration1)-jitterx2';
    jitterchecky1=interp1(tt(start:finish),jittery2,tt(start:finish)+dt1/duration1)-jittery2';
    
    jittercheckx2=interp1(tt(start:finish),jitterx2,tt(start:finish)+dt2/duration1)-jitterx2';
    jitterchecky2=interp1(tt(start:finish),jittery2,tt(start:finish)+dt2/duration1)-jittery2';
    
    jittercheckx3=interp1(tt(start:finish),jitterx2,tt(start:finish)+dt3/duration1)-jitterx2';
    jitterchecky3=interp1(tt(start:finish),jittery2,tt(start:finish)+dt3/duration1)-jittery2';



    %eliminate NaNs
    nanindex1=find(isnan(jittercheckx1));
    nanindex2=find(isnan(jittercheckx2));
    nanindex3=find(isnan(jittercheckx3));
    
    jittercheckx1(nanindex1)=0;
    jitterchecky1(nanindex1)=0;
    
    jittercheckx2(nanindex2)=0;
    jitterchecky2(nanindex2)=0;
    
    jittercheckx3(nanindex3)=0;
    jitterchecky3(nanindex3)=0;

    %function [ jitterx2, jittery2, realt, minError, linerate, TDI ]
%    disp(sprintf('minError is %0.20g', minError));
%    disp(sprintf('linerate is %0.20g', linerate));
%    disp(sprintf('TDI is %0.20g', TDI));
%
%    J=load('jjj.txt');
%    size(J)
%    size([jitterx2 jittery2])
%    disp(sprintf('Jitter errror is %g', max(max(abs(J-[jitterx2 jittery2])))));
%    T=load('ttt.txt');
%    size(T)
%    size(realt)
%    disp(sprintf('T errror is %g', max(max(abs(T-realt)))));
    
    toc

    tplot=t01;
    

    figure(400)
    set(gcf,'visible','off');
    clf
    subplot(3,6,[1 2]), hold on, plot(t1-tplot,offx1,'.r'), plot(realt1-tplot,xinterp1,'g'),
    plot(realt1-tplot,jittercheckx1+X1(1)/2,'y'),hold off, grid on

    T = {(realt1-tplot)', jitterx2, jittery2, ...
         (t1-tplot)', offx1',  xinterp1', (jittercheckx1+X1(1)/2)',  offy1',  yinterp1', (jitterchecky1+Y1(1)/2)', ...
         (t2-tplot)', offx2',  xinterp2', (jittercheckx2+X2(1)/2)',  offy2',  yinterp2', (jitterchecky2+Y2(1)/2)', ...
         (t3-tplot)', offx3',  xinterp3', (jittercheckx3+X3(1)/2)',  offy3',  yinterp3', (jitterchecky3+Y3(1)/2)'  ...
         };

    q = 0;
    nT = length(T);
    for p=1:nT
       q = max(q, length(T{p}));   
    end
    W = zeros(q, nT) + NaN;
    for ll=1:nT
       M = T{ll};
       [p, q] = size(M);
       M = reshape(M, p*q, 1);
       W(1:(p*q), ll) = M;
    end

    disp(sprintf('Writing plot.txt'));
    save('plot.txt', 'W', '-ascii', '-double');
        
    % fix here the precision of saving!!!
    A1X = [(t1-tplot)' offx1'];                       save('A1X.txt', 'A1X', '-ascii');
    B1X = [(realt1-tplot)' xinterp1'];                save('B1X.txt', 'B1X', '-ascii');
    C1X = [(realt1-tplot)' (jittercheckx1+X1(1)/2)']; save('C1X.txt', 'C1X', '-ascii');
    
    subplot(3,6,[7,8]), hold on, plot(t1-tplot,offy1,'.r'), plot(realt1-tplot,yinterp1,'g'),
    plot( realt1-tplot, jitterchecky1 + Y1(1) / 2,'y'),hold off, grid on

    A1Y = [(t1-tplot)' offy1'];                       save('A1Y.txt', 'A1Y', '-ascii');
    B1Y = [(realt1-tplot)' yinterp1'];                save('B1Y.txt', 'B1Y', '-ascii');
    C1Y = [(realt1-tplot)' (jitterchecky1+Y1(1)/2)']; save('C1Y.txt', 'C1Y', '-ascii');
    
    subplot(3,6,[3 4]), hold on, plot(t2-tplot,offx2,'.r'), plot(realt1-tplot,xinterp2,'g'),
    plot(realt1-tplot,jittercheckx2+X2(1)/2,'y'),hold off, grid on
    A2X = [(t2-tplot)' offx2'];                       save('A2X.txt', 'A2X', '-ascii');
    B2X = [(realt1-tplot)' xinterp2'];                save('B2X.txt', 'B2X', '-ascii');
    C2X = [(realt1-tplot)' (jittercheckx2+X2(1)/2)']; save('C2X.txt', 'C2X', '-ascii');
    
    subplot(3,6,[9 10]), hold on, plot(t2-tplot,offy2,'.r'), plot(realt1-tplot,yinterp2,'g'),
    plot( realt1-tplot, jitterchecky2 + Y2(1) / 2,'y'),hold off, grid on
    A2Y = [(t2-tplot)' offy2'];                       save('A2Y.txt', 'A2Y', '-ascii');
    B2Y = [(realt1-tplot)' yinterp2'];                save('B2Y.txt', 'B2Y', '-ascii');
    C2Y = [(realt1-tplot)' (jitterchecky2+Y2(1)/2)']; save('C2Y.txt', 'C2Y', '-ascii');
    
    subplot(3,6,[5 6]), hold on, plot(t3-tplot,offx3,'.r'), plot(realt1-tplot,xinterp3,'g'),
    plot(realt1-tplot,jittercheckx3+X3(1)/2,'y'),hold off, grid on 
    A3X = [(t3-tplot)' offx3'];                       save('A3X.txt', 'A3X', '-ascii');
    B3X = [(realt1-tplot)' xinterp3'];                save('B3X.txt', 'B3X', '-ascii');
    C3X = [(realt1-tplot)' (jittercheckx3+X3(1)/2)']; save('C3X.txt', 'C3X', '-ascii');

    subplot(3,6,[11 12]), hold on, plot(t3-tplot,offy3,'.r'), plot(realt1-tplot,yinterp3,'g'),
    plot( realt1-tplot, jitterchecky3 + Y3(1) / 2,'y'),hold off, grid on
    A3Y = [(t3-tplot)' offy3'];                       save('A3Y.txt', 'A3Y', '-ascii');
    B3Y = [(realt1-tplot)' yinterp3'];                save('B3Y.txt', 'B3Y', '-ascii');
    C3Y = [(realt1-tplot)' (jitterchecky3+Y3(1)/2)']; save('C3Y.txt', 'C3Y', '-ascii');
    
    subplot(3,6,[13 15]), hold on, plot(realt1-tplot,jitterx2), hold off, grid on
    A4X = [(realt1-tplot)' jitterx2];                save('A4X.txt', 'A4X', '-ascii');
    
    subplot(3,6,[16 18]), hold on, plot(realt1-tplot,jittery2), hold off, grid on
    A4Y = [(realt1-tplot)' jittery2];                save('A4Y.txt', 'A4Y', '-ascii');

    return


