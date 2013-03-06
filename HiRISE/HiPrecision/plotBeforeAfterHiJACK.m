function [ ] = plot_before_after_hijitter( filepath1,filepath2, obs, first_ccd, last_ccd)
% PLOT_BEFORE_AFTER_HIJITTER plots sample and line offsets from hijitreg
% flat files from the balance cubes and from the dejittered cubes.
%   filepath  = path to the correlation data for the image
% example filepath: '../Mojave_test_data/'
% example observation number: 'PSP_001481_1875'

figure1 = figure('Name',obs);


%-------------------------------------------------------------------------%
% get the hijitreg data from the balance cubes
%-------------------------------------------------------------------------%
a1 = subplot(2,1,1), box on; hold on
a2 = subplot(2,1,2), box on; hold on
title(a1,[obs,'_RED'],'Interpreter','none')
ylabel(a1,'Sample Offsets (pixels)')
ylabel(a2,'Line Offsets (pixels)'),xlabel(a2,'Image Time (s)')


for n=first_ccd:last_ccd-1
    number=int2str(n);
    nextnum=int2str(n+1);
    pair=[number,nextnum];


    textdata = fopen([filepath1,obs,'_RED',number,'-RED',nextnum,'_prehijack.flat.tab'], 'r');
    
    % read the match cube start time from header
    start_time = textscan(textdata, '%*c %*s %f64 %*[^\n]', 1, 'headerlines', 37);
    
    % read the data
    data = textscan(textdata, '%f64 %f64 %f64 %f64 %f64 %f64 %f %f %*f %*f %*f %*f','headerlines', 18);
    fclose(textdata);
    
%put the data into usable variables  
    t = data{1,4}(:,1);
    tnot = start_time{1,1}(:,1);
    t0 = tnot(1);
    str = sprintf('%0.8f', t(1));
    disp(str);    offx=data{1,7}(:,1)-data{1,2}(:,1);
    offy=data{1,8}(:,1)-data{1,3}(:,1);
    
    if (mod(n,2)==1)
        offx = -offx;
        offy = -offy;
    end    

% plot

  bo = plot(a1, t-t0, offx,'-rs','MarkerFaceColor','r','MarkerSize',2)
  co = plot(a2, t-t0, offy,'-rs','MarkerFaceColor','r','MarkerSize',2)
 
end

%-------------------------------------------------------------------------%
% get the hijitreg data from the dejittered cubes
%-------------------------------------------------------------------------%

for n=first_ccd:last_ccd-1
    number=int2str(n);
    nextnum=int2str(n+1);
    pair=[number,nextnum];


    textdata = fopen([filepath2,obs,'_RED',number,'-RED',nextnum,'_dejittered.flat.tab'], 'r');
    data = textscan(textdata, '%f64 %f64 %f64 %f64 %f64 %f64 %f %f %*f %*f %*f %*f','headerlines', 55);
    fclose(textdata);
    
% put the data into usable variables  
    t = data{1,4}(:,1);
%    t0 = t(1);
    offx=data{1,7}(:,1)-data{1,2}(:,1);
    offy=data{1,8}(:,1)-data{1,3}(:,1);
        
    if (mod(n,2)==1)
        offx = -offx;
        offy = -offy;
    end

% plot
  bd = plot(a1,t-t0, offx,'-bs','MarkerFaceColor','b','MarkerSize',2)
  cd = plot(a2,t-t0, offy,'-bs','MarkerFaceColor','b','MarkerSize',2)

end
legend(a2,[co,cd],'Original','Jitter Corrected','Location', 'NorthOutside','Orientation','horizontal')
legend(a2,'boxoff')




%annotation(figure1,'textbox',[0.01396 0.8964 0.05197 0.03283],...
%    'Interpreter','none',...
%    'String',{'dejittered'},...
%    'FitBoxToText','on',...
%    'LineStyle','none',...
%    'Color',[0 0 1]);


%annotation(figure1,'textbox',[0.01396 0.86357 0.05197 0.03283],...
%    'Interpreter','none',...
%    'String',{'original'},...
%    'FitBoxToText','on',...
%    'LineStyle','none',...
%    'Color',[1 0 0]);

%print -r200 -dpng foo.png
saveas( gcf, [filepath2,obs,'_RED.dejitplot.eps'], 'epsc2'); 
%saveas( gcf, [filepath2,obs,'_RED.dejitplot.png'], 'png');

