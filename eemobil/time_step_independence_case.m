%% Time step independce case
clc
close all
clear

dts = [0.2; 0.1; 0.05; 0.025;0.0125; 0.00625];
%dts = [0.2; 0.1; 0.05];

for timestepi=1:length(dts)
    
    addpath('./Configurations')

    should_use_images = false;
    
    load_data_set_5
    
    dt = dts(timestepi);

    traffic
    tveg(timestepi)=t(length(t));
    
    id = 5;
    p{timestepi} = y(2*id-1,:);
    v{timestepi} = y(2*id,:);
    pr{timestepi} = p{timestepi}(1:2^(timestepi-1):end);
    vr{timestepi} = v{timestepi}(1:2^(timestepi-1):end);
    
    figure(1);
    hold on;
    plot(t,p{timestepi})
    
    figure(2);
    hold on;
    plot(t,v{timestepi})    
    
    clearvars -except f1 f2 dts p v tveg pr vr
end
figure(1);
xlabel('t[s]')
ylabel('x[m]')
legend(cellstr(strcat('dt=',num2str(dts))), 'Location', 'southeast')

figure(2);
xlabel('t[s]')
ylabel('v[m/s]')
legend(cellstr(strcat('dt=',num2str(dts))), 'Location', 'southeast')

figure(3);
plot(tveg, '.','MarkerSize',20);
xlabel('dt[s]')
ylabel('t[s]')

minlengthpr = min(cellfun(@length,pr));
minlengthvr = min(cellfun(@length,vr));

figure(4);
for i=2:length(pr)
    a = pr{i-1}(1:1:minlengthpr);
    b = pr{i}(1:1:minlengthpr);
    hold on;
    plot((a - b)./(b))
end

figure(5);
for i=2:length(vr)
    a = vr{i-1}(1:1:minlengthvr);
    b = vr{i}(1:1:minlengthvr);
    hold on;
    plot((a - b)./(b))
end

