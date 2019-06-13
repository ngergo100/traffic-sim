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
hold all;
plot(t,y(:,1)-y(:,3) - consts.L, 'DisplayName','ode45','LineWidth',1.3);
set(gca,'fontsize',10');
xlabel('t[s]', 'fontsize',12');
ylabel('h[m]', 'fontsize',12');

figure2 = figure('Units','centimeters','Position',figure_size);
hold all;
plot(t,y(:,4)*3.6, 'DisplayName','ode45','LineWidth',1.3);
set(gca,'fontsize',10');
xlabel('t[s]', 'fontsize',12');
ylabel('v[km/h]', 'fontsize',12');

%% Grid parameters
dt = 0.01;
Tend = 100;
t(1) = 0;
N = ((Tend - t(1)) / dt) - 1;

x1(1) = y0(1);    % Initial position of car 1
x2(1) = y0(3);    % Initial position of car 2
v1(1) = y0(2);    % Initial velocity of car 1
v2(1) = y0(4);    % Initial velocity of car 2

%% Compute the solution on the grid
for i=1:N
    % Calculate current time stamp
    t(i + 1) = t(i) + dt;
    
    a1 = 0;
    v1(i + 1) = v1(i) + dt * a1;
    x1(i + 1) = x1(i) + dt * v1(i);

    params.v = v2(i);
    params.h = x1(i) - x2(i) - consts.L;
    params.delta_v = v2(i) - v1(i);
   
    a2 = idmee(params, consts);
    v2(i + 1) = v2(i) + dt * a2; 
    x2(i + 1) = x2(i) + dt * v2(i);
end

figure(figure1);
plot(t, x1 - consts.L - x2, 'DisplayName','EE','LineWidth',0.8);
legend('Location','northeast');
print('Resources/basic_2_car_headaway_case_3_2','-depsc');

figure(figure2);
plot(t, v2*3.6, 'DisplayName','EE','LineWidth',0.8);
legend('Location','northeast');
print('Resources/basic_2_car_velocity_case_3_2','-depsc');