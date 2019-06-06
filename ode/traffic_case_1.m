clc
clear
close all

%% Constants
consts.a_max = 1.5;      %% 0.8 to 2.5 m/s^s
consts.b_max = 1.67;     %% around 2 m/s^s
consts.v_0 = 130/3.6;    %% limit speed
consts.T = 1.8;          %% German recommendation at driving schools
consts.h_0 = 2;          %% standstill minimum gap
consts.delta = 4;        %% acceleration exponent
consts.L = 4.5;          %% cars length

T = 100;
y0 = [
    0;        % Initial position of car 1
    100/3.6   % Initial velocity of car 1
    -100;     % Initial position of car 2
    100/3.6   % Initial velocity of car 2
];
opts = odeset('RelTol',1e-4);
[t,y] = ode45(@(t,y) idm(t, y, consts), [0 T], y0, opts);

figure_size = [10,10,8,5];
figure1 = figure('Units','centimeters','Position',figure_size);
plot(t,y(:,1)-y(:,3) - consts.L);
set(gca,'fontsize',10');
xlabel('t[s]', 'fontsize',12');
ylabel('h[m]', 'fontsize',12');
print('Resources/basic_2_car_headaway_case_1_2','-depsc');

figure2 = figure('Units','centimeters','Position',figure_size);
plot(t,y(:,4)*3.6);
set(gca,'fontsize',10');
xlabel('t[s]', 'fontsize',12');
ylabel('v[km/h]', 'fontsize',12');
print('Resources/basic_2_car_velocity_case_1_2','-depsc');