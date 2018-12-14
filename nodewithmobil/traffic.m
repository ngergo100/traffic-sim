clc
clear
close all

%% Define the model
% parameters in models
% id, lane, initial position, initial velocity, ACC model
global models possible_lane_numbers
models = {
    11, 1, 0, 100/3.6, ChillModel;
    22, 1, -100, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    33, 1, -200, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    44, 1, -300, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    55, 1, -400, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    66, 1, -500, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    77, 1, -600, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
    88, 1, -700, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5));
};
lane_config = cat(1, models{:,2});
possible_lane_numbers = [1;2];

%% Initialization
for i=1:size(models, 1)
   y0(2*i-1) = models{i,3};
   y0(2*i) = models{i,4};
end
y0 = y0';
y = y0;

% Time initialization
t0 = 0;
T = 150;
dt = 0.5;
t(1) = 0;
N = ((T - t(1)) / dt) - 1;

%% Solving
for i=1:N
    t(i + 1) = t(i) + dt;
    [dy, next_lanes] = lanes(t(i), y(:,i), lane_config(:,i));
    y(:,i + 1) = y(:,i) + dt * dy;
    lane_config(:,i + 1) = next_lanes;
end

%% Post processing
identifiers = cat(1, models{:,1});
positions = y(1:2:end,:);
velocities = y(2:2:end,:);
lane_count = length(possible_lane_numbers);
cars_in_lane_count = prepare_lane_count(possible_lane_numbers, lane_config);

% Headways
headway_figure = figure('Name', 'Headways', 'NumberTitle', 'off');
headways = prepare_headways(positions, lane_config, identifiers);
headway_count = size(headways, 1);

for i=1:lane_count
    clear legendInfoHeadway
    for j=1:headway_count
        color = [1 - j/headway_count, j/headway_count, j/headway_count];
        hold on;
        subplots(i) = subplot(lane_count+1,1,i);
        headway = headways(j,:);
        lane = lane_config(j,:);
        plot(t(lane==possible_lane_numbers(i)), headway(lane==possible_lane_numbers(i)), '.', 'color', color)
        if ismember(possible_lane_numbers(i), lane) == 1
            if exist('legendInfoHeadway','var') == 1
                legendInfoHeadway{length(legendInfoHeadway) + 1} = ['h_{' num2str(identifiers(j)) '}'];
            else
                legendInfoHeadway{1} = ['h_{' num2str(identifiers(j)) '}'];
            end
        end
    end
    xlabel('t [s]')
    ylabel('Headway [m/s]')
    title(['Lane #' num2str(possible_lane_numbers(i))])
    legend(legendInfoHeadway)
end
set(subplots,'YLim',[min(headways(:))-1 max(headways(:))+1])

subplot(lane_count+1,1,lane_count+1)
plot(t,cars_in_lane_count)
xlabel('t [s]')
ylabel('Car count')

% Velocities
velocity_figure = figure('Name', 'Velocities', 'NumberTitle', 'off');
velocity_count = size(velocities, 1);

for i=1:lane_count
    clear legendInfoVelocity
    for j=1:velocity_count
        color = [1 - j/velocity_count, j/velocity_count, j/velocity_count];
        hold on;
        subplots(i) = subplot(lane_count+1,1,i);
        velocity = velocities(j,:);
        lane = lane_config(j,:);
        plot(t(lane==possible_lane_numbers(i)), velocity(lane==possible_lane_numbers(i)), '.', 'color', color)
        if ismember(possible_lane_numbers(i), lane) == 1
            if exist('legendInfoVelocity','var') == 1
            legendInfoVelocity{length(legendInfoVelocity) + 1} = ['v_{' num2str(identifiers(j)) '}'];
            else
            legendInfoVelocity{1} = ['v_{' num2str(identifiers(j)) '}'];
            end
        end
    end
    xlabel('t [s]')
    ylabel('Velocity [m/s]')
    title(['Lane #' num2str(possible_lane_numbers(i))]) 
    legend(legendInfoVelocity)
end
set(subplots,'YLim',[min(velocities(:))-0.5 max(velocities(:))+0.5])

subplot(lane_count+1,1,lane_count+1)
plot(t,cars_in_lane_count)
xlabel('t [s]')
ylabel('Car count')