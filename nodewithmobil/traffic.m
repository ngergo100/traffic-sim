clc
clear
close all

%% Define Models
% parameters in models
% id, initial position, initial velocity, ACC model, lane
global models possible_lane_numbers
models = {
    1, 0, 110/3.6, ChillModel;
    2, -100, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',120/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    3, -200, 90/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
};
lane_config = [1;1;1];
possible_lane_numbers = [1;2];

%% Initialization
for i=1:size(models, 1)
   y0(2*i-1) = models{i,2};
   y0(2*i) = models{i,3};
end
y0 = y0';

%% Duration
t0 = 0;
T = 100;
dt = 0.5;
t(1) = 0;
N = ((T - t(1)) / dt) - 1;
y = y0;

%% Solving
for i=1:N
    t(i + 1) = t(i) + dt;
    [dy, next_lanes] = lanes(t(i), y(:,i), lane_config(:,i));
    y(:,i + 1) = y(:,i) + dt * dy;
    lane_config(:,i + 1) = next_lanes;
end

identifiers = cat(1, models{:,1})';
velocities = y(2:2:end,:);

%% 
velocity_figure = figure('Name', 'Velocities', 'NumberTitle', 'off');

for i=1:size(velocities,1)
    hold on;
    velocity = velocities(i,:);
    lane = lane_config(i,:);
    plot(t(lane==1), velocity(lane==1),'+', t(lane==2), velocity(lane==2),'*')
end


