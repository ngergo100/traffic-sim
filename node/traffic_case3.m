clc
clear
close all

models = {
    0,    100/3.6, ChillModel;
    -50,  100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    -150, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    -200, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    -300, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    -350, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
};

for i=1:size(models)
   y0(2*i-1) = models{i,1};
   y0(2*i) = models{i,2};
end

y0 = y0';

T = 150;
opts = odeset('RelTol',1e-6);
[t,y] = ode45(@(t,y) lane(t, y, models), [0 T], y0, opts);

plotcount = size(models,1);
figure_size = [10,10,8,5];
figure1 = figure('Units','centimeters','Position',figure_size);

for i=1:plotcount
   hold on;
   plot(t,y(:,2*i)*3.6)
   legendInfoVelocity{i} = ['v' num2str(i)];
end
hold on;
legend(legendInfoVelocity,'FontSize',7)
set(gca,'fontsize',10');
ylabel('v[km/h]','fontsize',12')
xlabel('t[s]','fontsize',12')
print('Resources/n_car_velocity_case3','-depsc');

figure2 = figure('Units','centimeters','Position',figure_size);
for i=2:plotcount
    hold on;
    plot(t,y(:,2*i-3)-y(:,2*i-1)-4.5)
    legendInfoHeadaway{i-1} = ['h' num2str(i-1) '-' num2str(i)];
end
hold on;
legend(legendInfoHeadaway,'FontSize',7)
set(gca,'fontsize',10');
ylabel('h[m]','fontsize',12')
xlabel('t[s]','fontsize',12')
print('Resources/n_car_headway_case3','-depsc');