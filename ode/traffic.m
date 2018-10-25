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

[t,y] = ode45(@(t,y) idm(t, y, consts), [0 T], y0);

figure

subplot(3,2,1)
plot(t,y(:,2),'-o')
title('Velocity of car 1')
xlabel('t [s]')
ylabel('v [m/s]')

subplot(3,2,2)
plot(t,y(:,4),'-o')
title('Velocity of car 2')
xlabel('t [s]')
ylabel('v [m/s]')

subplot(3,2,3)
plot(t,y(:,1),'-o')
title('Position of car 1')
xlabel('t [s]')
ylabel('x [m]')

subplot(3,2,4)
plot(t,y(:,3),'-o')
title('Position of car 2')
xlabel('t [s]')
ylabel('x [m]')

subplot(3,2,5:6)
plot(t,y(:,1)-y(:,3),'-o')
title('Headway of car 2')
xlabel('t [s]')
ylabel('s [m]')