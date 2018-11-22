clc
clear
close all

%% Define Models
% parameters in models
% id, initial position, initial velocity, ACC model, lane
models = {
    1, 0, 100/3.6, ChillModel, 1;
    2, -20, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 1;
    3, -40, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 1;
    4, -60, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 1;
    5, -80, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 1;
    6, 0, 100/3.6, ChillModel, 2;
    7, -20, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 2;
    8, -40, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 2;
    9, -60, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 2;
    10, -80, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 2;
    11, 0, 100/3.6, ChillModel, 3
    12, -20, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 3;
    13, -40, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 3;
    14, -60, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 3;
    15, -80, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5)), 3;
};

%% Initialization
for i=1:size(models, 1)
   y0(2*i-1) = models{i,2};
   y0(2*i) = models{i,3};
end
y0 = y0';

%% Duration
T = 150;

%% Solver configuration
opts = odeset('RelTol',1e-5);

%% Solving
[t,y] = ode45(@(t,y) lanes(t, y, models), [0 T], y0, opts);

plotcount = size(models,1);
figure();

%% Plotting
for i=1:plotcount
   hold on;
   subplot(2,1,1)
   plot(t,y(:,2*i)*3.6)
   legendInfoVelocity{i} = ['v_{' num2str(models{i,1}) '}'];
end

for i=2:plotcount
    hold on;
    subplot(2,1,2)
    plot(t,y(:,2*i-3)-y(:,2*i-1))
    legendInfoHeadaway{i-1} = ['h_{' num2str(models{i-1,1}) '-' num2str(models{i,1}) '}'];
end
hold on;
subplot(2,1,1)
title('Velocity and Headway')
legend(legendInfoVelocity)
ylabel('v [km/h]')
xlabel('t [s]')
hold on;
subplot(2,1,2)
legend(legendInfoHeadaway)
ylabel('x [m]')
xlabel('t [s]')