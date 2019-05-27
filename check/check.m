clear
clc
close all

starting=2;
ending=200;
step=0.5;
h_stac = starting:step:ending;

for i = 1:length(h_stac)
    f = @(v_stac) idm_stac(v_stac, h_stac(i));
    velocity(i) = fsolve(f, 100);
end

figure_size = [10,10,15,10];
figure1 = figure('Units','centimeters','Position',figure_size);
hold all;
plot(h_stac, velocity * 3.6, 'LineWidth',2)
plot([0,64.5],[100,100],'color','r', 'LineWidth',0.5)
plot([64.5,64.5],[0,100],'color','r', 'LineWidth',0.5)
set(gca,'fontsize',10');
ylabel('vstac[km/h]', 'fontsize',12')
xlabel('hstac[m]', 'fontsize',12')
print('Resources/check_stationary_states','-depsc');