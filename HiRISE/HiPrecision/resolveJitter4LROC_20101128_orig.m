function [offx, offy ] = resolveJitter4LROC_20101128( imageid, rows , lineOffset, linetime)
% RESOLVEJITTER4LROC is a modification of resolveJitter4HIJACK and takes
% function [ jitterx2, jittery2, realt, error] = resolveJitter4LROC( filepath1, lineinterval, time )
% in data from coreg files from LROC NAC images to estimate camera jitter. 
%
% Outputs are the jitter in the x (sample) and y (line) directions in
% pixels, realt (ephemeris time at that translation), average error between
% the derived jitter function and the original data, linerate (line time
% read from flat files, used for fuction pixelSmear), TDI (also for
% pixelSmear calculations).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified 11/28/10 SM, changed the WindowSize for the bad points filter to
% 6 (instead of 5) b/c in one case a bad point near the end of a file made
% it through.
% Modified 3/13/10 SM, added text file output of jitter function.
% Modified 10/27/09 SM, commented out the initial complex filtering.
% Modified 10/27/09 SM, debugged the initial complex filtering of the data.
% Modified 9/29/09 SM, updated the bad points filter.
% Modified 8/24/09 SM, turned off plot visibility 
% Modified 8/7/09 by SM for LROC
%   - Changed indexing "Average multiple columns of data" block.
%     coreg was sometimes returning outliers in the first few rows  
%     that were not being eliminated.
%   - Updated commenting.
% Modified 6/15/2009 by Sarah Mattson for LROC.
%   - Takes in one data file as input (instead of three)
% Modified 7/13/09 by SM for LROC
%   - changed median filter window width to 1 from 2.
% Modified 7/6/09 by SM for LROC
%   - added line offset (as measured empirically) to input args
%   - changed phase tolerance coefficient from 0.01 to 0.0001.
%
% Written by Aaron Boyd and Sarah Mattson for HiROC as part of the 
%   process to describe and correct geometric distortions caused by jitter
%   in HiRISE images. Original version written approximately 6/2008.
%
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

%% Tolerance Coefficients
%tolerance for the error
errortol=.0000000001;
repetitions=50;

%tolerance coefficient for the phase difference
tolcoef=.00001;

%% Gather data

flatfile = [imageid,'.flat.tab'];
%get the data from the file
textdata = fopen(flatfile, 'r');
%imageLength = textscan(textdata1, '%*s %*s %f',1,'headerlines',6);
% imageLength = time;
data = textscan(textdata, '%f,%f,%f,%f,%f,%f,%f ','headerlines', 1);
fclose('all');
%imageLength = imageLength{1,1}(1);

%% Put the data into usable variables

dt = lineOffset * linetime;           % line separation * line time for the image
t = data{1,4}(:,1) * linetime;       % turn line number to line time

%t = data{1,4}(:,1);                      % line number

offx = data{1,5}(:,1);
offy = data{1,6}(:,1);


%% Filter out the bad points.

 windowSize = 6; 
 windowWidth = 1.5;
 AveOffX = medfilt1(offx,windowSize);
 AveOffY = medfilt1(offy,windowSize);
 DiffX = offx - AveOffX;
 DiffY = offy - AveOffY;
 AdiffX = abs(DiffX);
 AdiffY = abs(DiffY);
 BadX = find(AdiffX > windowWidth);
 BadY = find(AdiffY > windowWidth);
 BadXY = [BadX; BadY];
 outofRange = unique(BadXY);
 
%% Remove the bad points from the x and y offset data
 x = offx;
 y = offy;
 tt = t;
 x(outofRange) = [];
 y(outofRange) = [];
 tt(outofRange) = [];


%% Average multiple columns of offset data.
a = 1;
ttt = tt(a);

combinedX(a)= x(a);
combinedY(a)= y(a);

repeat=1;
for n=2:length(tt),
        if tt(n)==tt(n-1),
            repeat=repeat+1;
            combinedX(a)=x(n)+combinedX(a);
            combinedY(a)=y(n)+combinedY(a);
            ttt(a)=tt(n);
        else
           combinedX(a)= combinedX(a)/repeat;
           combinedY(a)= combinedY(a)/repeat;

            repeat=1;
            a=a+1;

            ttt(a)=tt(n);
            combinedX(a)=x(n);
            combinedY(a)=y(n);
        end
end
combinedX(end)=combinedX(end)/repeat;
combinedY(end)=combinedY(end)/repeat;
t=ttt;
t01 = t(1);                                      % 1st sampled line

offx = combinedX;
offy = combinedY;


%% for improved speed use powers of 2 in Fourier transform
% dividing by the line interval used in hijitreg
% nfft=2^(nextpow2(imageLength(1,1)/ lineinterval));

nfft=2^(nextpow2(rows));

% %put the data into usable variables
% t = data{1,4}(:,1) * linetime;       % turn line number to line time
% t01 = t(1);                                      % 1st sampled line
% 
% offx = data{1,5}(:,1);
% offy = data{1,6}(:,1);


% just for LROC NAC testing, normalize line offsets.
%offy =  offy - lineOffset;     % Took this line out because newer coreg
%algorithm already "normalizes" the line offsets.

duration=t(end)-t01;

% %% Filter out the bad points.
% 
%  windowSize = 5; 
%  windowWidth = 1.5;
%  AveOffX = medfilt1(offx,windowSize);
%  AveOffY = medfilt1(offy,windowSize);
%  DiffX = offx - AveOffX;
%  DiffY = offy - AveOffY;
%  AdiffX = abs(DiffX);
%  AdiffY = abs(DiffY);
%  BadX = find(AdiffX > windowWidth);
%  BadY = find(AdiffY > windowWidth);
%  BadXY = [BadX; BadY];
%  BadPoints = unique(BadXY);
% 
% % magnitude=(offx.^2+offy.^2).^(1/2);
% % avemag= medfilt1(magnitude, windowSize);
% % upper = magnitude - windowWidth - avemag;
% % lower = magnitude + windowWidth - avemag;
% % tooHigh = find( upper > 0);
% % tooLow  = find( lower < 0);
% % outofRange=[tooHigh; tooLow];
% 
% 
% %% Average multiple columns of offset data.
% a = 1;
% ttt = t(a);
% x(a)= offx(a);
% y(a)= offy(a);
% repeat=1;
% for n=2:length(t),
%     testing = ~any(outofRange==n);
%     if testing
%         if t(n)==t(n-1),
%             repeat=repeat+1;
%             x(a)=offx(n)+x(a);
%             y(a)=offy(n)+y(a);
%             ttt(a)=t(n);
%         else
%             x(a)=x(a)/repeat;
%             y(a)=y(a)/repeat;
% 
%             repeat=1;
%             a=a+1;
% 
%             ttt(a)=t(n);
%             x(a)=offx(n);
%             y(a)=offy(n);
%         end
%     end
% end
% x(end)=x(end)/repeat;
% y(end)=y(end)/repeat;
% t=ttt;
% 
% % for n = 1:length(outofRange),
% %  if a == outofRange(n),
% %      a = a+1;
% %  end
% % end
% % ttt = t(a);
% % x(1)= offx(a);
% % y(1)= offy(a);
% % repeat=1;
% % a = 1;
% % for n=2:length(t),
% %     testing = ~any(outofRange==n);
% %     if testing
% %         if t(n)==t(n-1),
% %             repeat=repeat+1;
% %             x(a)=offx(n)+x(a);
% %             y(a)=offy(n)+y(a);
% %             ttt(a)=t(n);
% %         else
% %             x(a)=x(a)/repeat;
% %             y(a)=y(a)/repeat;
% % 
% %             repeat=1;
% %             a=a+1;
% % 
% %             ttt(a)=t(n);
% %             x(a)=offx(n);
% %             y(a)=offy(n);
% %         end
% %     end
% % end
% % x(end)=x(end)/repeat;
% % y(end)=y(end)/repeat;
% % t=ttt(2:end);
% % 
% % offx = x(2:end);
% % offy = y(2:end);
% % 
% % a = length(t);
% 
% offx = x;
% offy = y;

%%

%plotting the original offsets
figure(200)
 set(gcf,'visible','off'); % turn off plot visibility
subplot(2,1,1),hold off, plot(t, offx, 'r.'), ylabel('Sample Offsets'), title([flatfile,'_coregData'], 'Interpreter', 'none')
subplot(2,1,2),hold off, plot(t, offy, 'r.'), ylabel('Line Offsets'), xlabel('Image Time (s)')


%% smoothing the offsets to reduce noise
%sets up padding so the data are not distorted
%frontPadding = floor((nfft-a/2));
%backPadding  = ceil((nfft-a/2));


% %filters the data
% offx = ifft(fft([ones(1,frontPadding)*offx(1), offx, ones(1,backPadding)*offx(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
% offx = offx((frontPadding+1):(frontPadding+a));
% 
% offy = ifft(fft([ones(1,frontPadding)*offy(1), offy, ones(1,backPadding)*offy(a)],nfft*2).*exp(-(2/nfft*[0:(nfft-1) -(nfft):-1]).^2),nfft*2,'symmetric');
% offy = offy((frontPadding+1):(frontPadding+a));


%% plotting the offsets
figure(200) 
 set(gcf,'visible','off'); % turn off plot visibility
subplot(2,1,1),hold on, plot(t, offx)
subplot(2,1,2),hold on, plot(t, offy)
saveas( gcf, [flatfile,'.offsets_plot.png'], 'png');
 close(gcf)



%clear the variables no longer used to decrease memory consumption
clear a x y ttt repeat frontPadding backPadding n column;
clear testing n a x y ttt repeat frontPadding backPadding tooLow* toohigh*;
clear outofRange* magnitude* avemag* upper* lower* windowSize windowWidth ;
clear repeat imageLength data* textdata* column;


%the start and end time of the image
start  = 1;
finish = nfft;


%making time regularly spaced
% tt is an evenly spaced row vector of timing from 0 to less than 1. The
% number of columns is the same as nfft.
   tt = (0:(nfft-1))/(nfft);
% realt is a column vector that converts the even spacing to line number or
% line time, depending on what data type is read in. It has nfft rows.
realt = (0:(nfft-1))/(nfft-1)*duration+t01;


% The original data points, 'offx' or 'offy' interpolated at the original time or 
% line number 't', are interpolated over the evenly spaced 'realt' which 
% has a power of 2 number of points for optimizing the FFT. 

% The interpolation algorithm is a piecewise cubic Hermite interpolation,
% extrapolated at end points to the mean offset value.
% 't01' is subtracted from both 't' and 'realt' to set the starting point to zero. 
xinterp = interp1(t - t01, offx, realt-t01, 'pchip', mean(offx));
yinterp = interp1(t - t01, offy, realt-t01, 'pchip', mean(offy));


% 'freq' is a row vector of N frequencies where N=0,1,2,...,N and N=nfft/2. 
% These will be the frequencies of the Fourier transform.
freq = linspace(0, nfft/2-1, nfft/2);


%preallocating loops
overx = zeros(repetitions, nfft);
overy = overx;


%taking the fourier transform of the offsets
X = 2 * fft(xinterp,nfft)/nfft;
Y = 2 * fft(yinterp,nfft)/nfft;


%separating sines and cosines
XA = real(X(1:(nfft/2)));
XB =-imag(X(1:(nfft/2)));

YA = real(Y(1:(nfft/2)));
YB =-imag(Y(1:(nfft/2)));


%calculates the phase difference
ddt = mod(dt/duration*2*pi.*freq,2*pi);


%creates a matrix for times and frequencies
timesfreq = 2*pi*freq'*tt;


%these are the coefficients for the frequencies
aaax = diag(-1/2*(-XA.*cos(ddt)+sin(ddt).*XB-XA)./sin(ddt));
aaay = diag(-1/2*(-YA.*cos(ddt)+sin(ddt).*YB-YA)./sin(ddt));

bbbx = diag(-1/2*( XB.*cos(ddt)+sin(ddt).*XA+XB)./sin(ddt));
bbby = diag(-1/2*( YB.*cos(ddt)+sin(ddt).*YA+YB)./sin(ddt));
clear XA XB YA YB


%create series of sines and cosines
overxx = aaax*sin(timesfreq)+bbbx*cos(timesfreq);
overyy = aaay*sin(timesfreq)+bbby*cos(timesfreq);
clear aaax aaay bbbx bbby


%starting a loop to find correct phase tol
k=0;
aveerror=errortol;

while aveerror>=errortol && k<repetitions
    k=k+1;
    %setting the phase tolerance
    phasetol = (k)*tolcoef;

    %null the frequencies that cause a problem
    nullindex=abs(ddt)<phasetol | (2*pi-abs(ddt))< phasetol;

    overxxx=overxx;
    overyyy=overyy;
    overxxx(nullindex,:)=0; overyyy(nullindex,:)=0;

 
%     %finding which ones are zero
%     overxxx1(nullindex1,:)=(overxxx2(nullindex1,:)+overxxx3(nullindex1,:))/(~isequal(zeros(1,5),overxxx2(nullindex1,1:5))+~isequal(zeros(1:5),overxxx3(nullindex1,1:5)));
% 
%     overyyy1(nullindex1,:)=(overyyy2(nullindex1,:)+overyyy3(nullindex1,:))/(~isequal(zeros(1,5),overyyy2(nullindex1,1:5))+~isequal(zeros(1:5),overyyy3(nullindex1,1:5)));
%     overyyy2(nullindex2,:)=(overyyy2(nullindex2,:)+overyyy3(nullindex2,:))/(~isequal(zeros(1,5),overyyy1(nullindex2,1:5))+~isequal(zeros(1:5),overyyy3(nullindex2,1:5)));
%     overyyy3(nullindex3,:)=(overyyy2(nullindex3,:)+overyyy1(nullindex3,:))/(~isequal(zeros(1,5),overyyy2(nullindex3,1:5))+~isequal(zeros(1:5),overyyy1(nullindex3,1:5)));

    %adding all frequencies together
%     overxxx=(overxxx1+overxxx2+overxxx3)/3;
        overxxx(isnan(overxxx(:,1)),:)=0;
%     overyyy=(overyyy1+overyyy2+overyyy3)/3;
        overyyy(isnan(overyyy(:,1)),:)=0;
    overx(k,:)=sum(overxxx,1);
    overy(k,:)=sum(overyyy,1);

    jitterx=overx(k,:)-overx(k,1);
    jittery=overy(k,:)-overy(k,1);

    
    %checking
    jittercheckx=interp1(tt(start:finish),jitterx,tt(start:finish)+dt/duration)-jitterx;
    jitterchecky=interp1(tt(start:finish),jittery,tt(start:finish)+dt/duration)-jittery;
    


    %eliminate NaNs
    jittercheckx(isnan(jittercheckx))=0;
    jitterchecky(isnan(jitterchecky))=0;
    
    aveerror=mean(1/6 * (abs(xinterp - (jittercheckx+X(1)/2)))+ (abs(yinterp - (jitterchecky+Y(1)/2))))
    errors(k)=aveerror;

end

%saving the min error for the phase difference
minerror=min(errors);
minindex=find(errors==minerror,1,'first')



    jitterx=overx(minindex,:)-overx(minindex,1);
    jittery=overy(minindex,:)-overy(minindex,1);

    
    %checking
    jittercheckx=interp1(tt(start:finish),jitterx,tt(start:finish)+dt/duration)-jitterx;
    jitterchecky=interp1(tt(start:finish),jittery,tt(start:finish)+dt/duration)-jittery;
   

    %eliminate NaNs
    jittercheckx(isnan(jittercheckx))=0;
    jitterchecky(isnan(jitterchecky))=0;
   
    

%     %plotting
%     k=minindex;
%     tplot=t01;
%     figure(k)
%     clf
%     subplot(2,2,1), hold on, plot(t-tplot,offx,'.r'), plot(realt-tplot,xinterp,'g'),
%     plot(realt-tplot,jittercheckx+X(1)/2,'y'),hold off
%     subplot(2,2,2), hold on, plot(t-tplot,offy,'.r'), plot(realt-tplot,yinterp,'g'),
%     plot( realt-tplot, jitterchecky + Y(1) / 2,'y'),hold off
%     subplot(2,2,3), hold on, plot(realt - tplot , jitterx) , hold off
%     subplot(2,2,4), hold on, plot(realt - tplot , jittery) , hold off
%     figure(k+100)
%   tplot=t01;
%    clf
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
    clear jittercheckx 
    clear jitterchecky 
    clear overx overy errors minerror aveerror




%starting a loop to find the correct filter size
k=0;
aveerror=errortol;
jitterxx=zeros(repetitions,nfft);
jitteryy=jitterxx;
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
    jittercheckx=interp1(tt(start:finish),jitterxx(k,:),tt(start:finish)+dt/duration)-jitterxx(k,:);
    jitterchecky=interp1(tt(start:finish),jitteryy(k,:),tt(start:finish)+dt/duration)-jitteryy(k,:);
    
    %eliminate NaNs
    nanindex=isnan(jittercheckx);
 
    
    jittercheckx(nanindex)=0;
    jitterchecky(nanindex)=0;
    
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

    aveerror=mean(1/6*(abs(xinterp -(jittercheckx + X(1) / 2)) + abs(yinterp-(jitterchecky + Y(1) / 2))))
    errors(k)=aveerror;
end
    

minerror=min(errors);
minindex=find(errors==minerror,1,'first')
error=errors(minindex);
realt=realt';

jitterx2=jitterxx(minindex,:)';
jittery2=jitteryy(minindex,:)';


%checking
    jittercheckx=interp1(tt(start:finish),jitterx2,tt(start:finish)+dt/duration)-jitterx2';
    jitterchecky=interp1(tt(start:finish),jittery2,tt(start:finish)+dt/duration)-jittery2';
    


    %eliminate NaNs
    nanindex=find(isnan(jittercheckx));
 
    
    jittercheckx(nanindex)=0;
    jitterchecky(nanindex)=0;
    


    figure(400)
  set(gcf,'visible','off'); % turn off plot visibility
    clf
    subplot(2,2,1), hold on, plot(t-tplot,offx,'.r'), plot(realt-tplot,xinterp,'g'),
    plot(realt-tplot,jittercheckx+X(1)/2,'y'), xlabel('Image Time (s)'), ylabel('Pixels'), title('Sample Offsets'), hold off, grid on
    subplot(2,2,2), hold on, plot(t-tplot,offy,'.r'), plot(realt-tplot,yinterp,'g'),
    plot( realt-tplot, jitterchecky + Y(1) / 2,'y'), xlabel('Image Time (s)'), ylabel('Pixels'), title('Line Offsets'), hold off, grid on
    
%     subplot(3,6,[3 4]), hold on, plot(t2-tplot,offx2,'.r'), plot(realt1-tplot,xinterp2,'g'),
%     plot(realt1-tplot,jittercheckx2+X2(1)/2,'y'),hold off, grid on 
%     subplot(3,6,[9 10]), hold on, plot(t2-tplot,offy2,'.r'), plot(realt1-tplot,yinterp2,'g'),
%     plot( realt1-tplot, jitterchecky2 + Y2(1) / 2,'y'),hold off, grid on
%     
%     subplot(3,6,[5 6]), hold on, plot(t3-tplot,offx3,'.r'), plot(realt1-tplot,xinterp3,'g'),
%     plot(realt1-tplot,jittercheckx3+X3(1)/2,'y'),hold off, grid on 
%     subplot(3,6,[11 12]), hold on, plot(t3-tplot,offy3,'.r'), plot(realt1-tplot,yinterp3,'g'),
%     plot( realt1-tplot, jitterchecky3 + Y3(1) / 2,'y'),hold off, grid on
%     
    subplot(2,2,3), hold on, plot(realt-tplot,jitterx2), xlabel('Image Time (s)'), ylabel('Pixels'), title('Jitter Function - Sample Direction'), hold off, grid on 
    subplot(2,2,4), hold on, plot(realt-tplot,jittery2), xlabel('Image Time (s)'), ylabel('Pixels'), title('Jitter Function - Line Direction'), hold off, grid on

   saveas( gcf, [flatfile,'.jitter_plot.png'], 'png');

 close(gcf)

%% Write out the text file of the jitter function

data=[jitterx2,jittery2,realt];

fid=fopen([imageid,'_jitter.txt'], 'wt');
fprintf(fid,'# Using image %s the jitter was found with an\n',imageid);
fprintf(fid,'# Average Error of %f\n',error);
%fprintf(fid,'# Maximum Cross-track pixel smear %f\n', maxSmearSample);
%fprintf(fid,'# Maximum Down-track pixel smear %f\n', maxSmearLine);
%fprintf(fid,'# Maximum Pixel Smear Magnitude %f\n', maxSmearMag);
fprintf(fid,'#\n# Sample_Offset          Line_Offset            Image_Time \n');
fprintf(fid,'%12.16f     %12.16f     %12.9f\n', data');
fclose(fid);
