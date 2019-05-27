%% Time step independce case
clc
close all
clear

dts = [0.4; 0.2; 0.1; 0.05; 0.025; 0.0125];
%dts = [0.4; 0.2; 0.1; 0.05];
figure_size = [10,10,8,5];

f1 = figure('Name','Position', 'Units','centimeters', 'Position',figure_size);
f2 = figure('Name','Velocity', 'Units','centimeters', 'Position',figure_size);

for timestepi=1:length(dts)
    
    addpath('./Configurations')

    should_use_images = false;
    
    load_data_set_7 % Blending IDM and MOBIL
    
    dt = dts(timestepi);

    traffic
    tveg(timestepi)=t(length(t));
    
    id = 1;
    p{timestepi} = y(2*id-1,:);
    v{timestepi} = y(2*id,:);
    pr{timestepi} = p{timestepi}(1:2^(timestepi-1):end);
    vr{timestepi} = v{timestepi}(1:2^(timestepi-1):end);
    
    figure(f1);
    hold on;
    plot(t,p{timestepi})
    
    figure(f2);
    hold on;
    plot(t,v{timestepi})    
    
    clearvars -except f1 f2 dts p v tveg pr vr figure_size
end
figure(f1);
set(gca,'fontsize',8')
xlabel('t[s]')
ylabel('x[m]')
legend(cellstr(strcat('dt=',num2str(dts))), 'Location', 'northwest', 'FontSize',9)
print('Resources/timestepi_p','-depsc');

figure(f2);
set(gca,'fontsize',8')
xlabel('t[s]')
ylabel('v[m/s]')
legend(cellstr(strcat('dt=',num2str(dts))), 'Location', 'southeast', 'FontSize',9)
print('Resources/timestepi_v','-depsc');

figure('Name','Time', 'Units','centimeters', 'Position',figure_size);
plot(tveg, '.','MarkerSize',16);
set(gca,'fontsize',8')
xlabel('dt[s]')
ylabel('t[s]')
print('Resources/timestepi_t','-depsc');

minlengthpr = min(cellfun(@length,pr));
minlengthvr = min(cellfun(@length,vr));

figure('Name','RelativePos', 'Units','centimeters', 'Position',figure_size);
for i=2:length(pr)
    a = pr{i-1}(1:1:minlengthpr);
    b = pr{i}(1:1:minlengthpr);
    hold on;
    plot(100*abs((a - b)./(b)))
end
set(gca,'fontsize',8')
ylabel('relativehibap[%]')
print('Resources/timestepi_relative_p','-depsc');

figure('Name','RelativeVel', 'Units','centimeters', 'Position',figure_size);
for i=2:length(vr)
    a = vr{i-1}(1:1:minlengthvr);
    b = vr{i}(1:1:minlengthvr);
    hold on;
    plot(100*abs((a - b)./(b)))
end
set(gca,'fontsize',8')
ylabel('relativehibav[%]')
print('Resources/timestepi_relative_v','-depsc');

