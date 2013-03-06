function [maxSmearS, maxSmearL, maxSmearMag] = pixelSmear (Sample, Line, T, linerate, TDI, imagelocation, imageid)
% PIXELSMEAR finds max smeared pixel amount in the image from derived
% jitter function.
%
% Sample is the sample offsets from the jitter function
% Line is the line offsets from the jitter function
% T is the ephemeris time from the jitter function
% linerate is read from the flat file, equivalent to TDI
%
% Pixel smear due to jitter is calculated by interpolating the jitter 
% function at intervals equivalent to the linerate.
% Then the difference is taken over that interval and multiplied by the TDI.
% This provides an estimated minimum for pixel smear. If the motion that
% caused the smear is not captured in the jitter derivation, then it cannot
% be plotted here.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Sarah Mattson for HiROC as part of the 
%   process to describe and correct geometric distortions caused by jitter
%   in HiRISE images. Original version written 9/3/2008.
%
% CVS ID: $Id: pixelSmear.m,v 1.1 2009/04/15 23:13:26 smattson Exp $
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
%--------------------------------------------------------------------------

% interpolate the jitter function at intervals equivalent to the linerate
disp(sprintf('linerate is %g', linerate));

disp(sprintf('----------------------- temporary!!!----------------------'));
Tbk = T; T = T - T(1);
      
xi = T(1):linerate:T(end);
%xi = 0:linerate:(T(end)-T(1));
% sample
yis = interp1(T,Sample,xi,'pchip');
% line
yil = interp1(T,Line,xi,'pchip');

disp(sprintf('----------------------- temporary!!!----------------------'));
T = Tbk; xi = xi + T(1);

% calculate the rate of change with respect to the linerate
n=length(xi);

% in the sample direction
dysdx = zeros(1,n);
for k=1:n-1, dysdx(k) = (yis(k+1) - yis(k))*TDI; end

% in the line direction
dyldx = zeros(1,n);
for k=1:n-1, dyldx(k) = (yil(k+1) - yil(k))*TDI; end

% calculate the magnitude of the smear
magSmear = sqrt(dysdx.^2 + dyldx.^2);


% output the max smear values
[Cs,Is] = max(abs(dysdx));
maxSmearS = dysdx(Is);

% $$$ maxSmearS
% $$$ max(abs(dysdx))

% $$$ disp(sprintf('n=%g', n));
% $$$ B=load('out.txt');
% $$$ size(magSmear)
% $$$ size(B)
% $$$ max(abs(B-magSmear'))
% $$$ max(abs(B-magSmear')./abs(magSmear'))
% $$$ return

[Cl,Il] = max(abs(dyldx));
maxSmearL = dyldx(Il);

[Cm,Im] = max(abs(magSmear));
maxSmearMag = magSmear(Im);

% plot the smear in the sample direction
figure (1001)
set(gcf,'visible','off');
subplot (3,1,1), plot (xi-xi(1), dysdx), ylabel('Pixels'), title([imageid,' Cross-track Smear'],'Interpreter','none');
% plot the smear in the line direction
subplot (3,1,2), plot(xi-xi(1), dyldx), ylabel('Pixels'), title([imageid,' Down-track Smear'],'Interpreter','none');
%plot the smear magnitude
subplot (3,1,3), plot(xi-xi(1), magSmear), xlabel('Seconds'), ylabel('Pixels'), title([imageid,' Smear Magnitude'],'Interpreter','none');

% save the plot as a png
saveas (1001, [imagelocation,imageid,'_Pixel_Smear.png'],'png');

% Make a text file of smear data.
smeardata = [dysdx; dyldx; xi];
fid=fopen([imagelocation,imageid,'_smear.txt'], 'wt');
disp(sprintf('Writing: %s', [imagelocation,imageid,'_smear.txt']));
fprintf(fid,'# Smear values are calculated from the derived jitter function for %s.\n',imageid);
fprintf(fid,'# Maximum Cross-track pixel smear %f\n', maxSmearS);
fprintf(fid,'# Maximum Down-track pixel smear %f\n', maxSmearL);
fprintf(fid,'# Maximum Pixel Smear Magnitude %f\n', maxSmearMag);
fprintf(fid,'\n# Sample                 Line                   EphemerisTime \n');
fprintf(fid,'%12.16f     %12.16f     %12.9f\n', smeardata);
fclose(fid);


