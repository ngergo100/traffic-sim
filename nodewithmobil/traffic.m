clc
clear
close all

%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
global models possible_lane_numbers latest_lane_changes_start latest_lane_changes_end weighted_average_acceleration_calculation_enabled
models = {
     11, 1, 0, 0,   0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
     22, 1, 0, -10, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
     33, 1, 0, -20, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
     44, 1, 0, -30, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 20, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
     55, 1, 0, -55, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[10,12;16,18]));
     66, 1, 0, -65, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
     77, 1, 0, -75, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
     88, 1, 0, -85, 0/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',50/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5, 'time_to_change_lane',2, 'lane_change_duration',2, 'not_paying_attention',[]));
};

lane_config_source = cat(1, models{:,2});
lane_config_target = cat(1, models{:,3});
latest_lane_changes_start = zeros(length(lane_config_target),1);
latest_lane_changes_end = zeros(length(lane_config_source),1);
weighted_average_acceleration_calculation_enabled = false;
possible_lane_numbers = [1;2];

%% Initialization
for i=1:size(models, 1)
   y0(2*i-1) = models{i,4};
   y0(2*i) = models{i,5};
end
y0 = y0';
y = y0;

% Time initialization
t0 = 0;
dt = 0.2;
T = 30;
t(1) = 0;
N = ((T - t(1)) / dt) - 1;

%% Solving
for i=1:N
    t(i+1) = t(i) + dt;
    [dy, next_source_lanes, next_target_lanes] = lanes(t(i), y(:,i), lane_config_source(:,i), lane_config_target(:,i));
    y(:,i+1) = y(:,i) + dt * dy;
    lane_config_source(:,i+1) = next_source_lanes;
    lane_config_target(:,i+1) = next_target_lanes;
end

%% Post processing
identifiers = cat(1, models{:,1});
positions = y(1:2:end,:);
velocities = y(2:2:end,:);
lane_count = length(possible_lane_numbers);
cars_in_lane_count = prepare_lane_count(possible_lane_numbers, lane_config_source);

% Headways
headway_figure = figure('Name', 'Headways', 'NumberTitle', 'off');
headways = prepare_headways(positions, lane_config_source, identifiers);
headway_count = size(headways, 1);

for i=1:lane_count
    clear legendInfoHeadway
    for j=1:headway_count
        color = [1 - j/headway_count, j/headway_count, j/headway_count];
        hold on;
        subplots(i) = subplot(lane_count+1,1,i);
        headway = headways(j,:);
        lane = lane_config_source(j,:);
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
    ylabel('Headway [m]')
    title(['Lane #' num2str(possible_lane_numbers(i))])
    legend(legendInfoHeadway, 'Location', 'eastoutside')
end
set(subplots,'YLim',[min(headways(:))-1 max(headways(:))+1])

subplot(lane_count+1,1,lane_count+1)
plot(t,cars_in_lane_count)
legend(cellstr(num2str(possible_lane_numbers)), 'Location', 'eastoutside')
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
        lane = lane_config_source(j,:);
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
    legend(legendInfoVelocity, 'Location', 'eastoutside')
end
set(subplots,'YLim',[min(velocities(:))-0.5 max(velocities(:))+0.5])

subplot(lane_count+1,1,lane_count+1)
plot(t,cars_in_lane_count)
legend(cellstr(num2str(possible_lane_numbers)), 'Location', 'eastoutside')
xlabel('t [s]')
ylabel('Car count')

%% Animation
v = VideoWriter('video','MPEG-4');
v.Quality = 50;
open(v);
ratio = 400/1200;
width = 1200;
fig = figure('Renderer', 'painters', 'Position', [0 0 width width*ratio]);
[img, map, alphachannel] = imread('bugattismall.png');
carToFollow = 11;
indexOfChosenCar = find(identifiers==carToFollow);
path_limit = [min(positions(:)) max(positions(:))];

for i = 1:size(positions,2)
    clf(fig)
    for j = 1:length(possible_lane_numbers)-1
        path = path_limit(1);
        while path < path_limit(2)
            plot([path path+8],[(possible_lane_numbers(j)+0.5)*10 (possible_lane_numbers(j)+0.5)*10],'b');
            path = path + 30;
            hold on;
        end
    end
    for j = 1:size(positions,1)
        
        % Group follower
        % Minimum and maximum of current positions vector
        xlimit = [min(positions(:,i))-10 max(positions(:,i))+10];
        
        % Car follower
        %xlimit = [min(positions(indexOfChosenCar,i))-100 max(positions(indexOfChosenCar,i))+100];
        
        ylimit = [0 (xlimit(2) - xlimit(1))*ratio];
        xlim(xlimit);
        ylim(ylimit);
        xPos = positions(j,i);
        
        if lane_config_target(j,i) ~= 0
            [starting, ending] = find_start_end(i, lane_config_target(j,:));
            elapsed_steps = (i-starting)/(ending-starting);
            yPos = (lane_config_source(j,i) + (lane_config_target(j,i) - lane_config_source(j,i)) * elapsed_steps) * 10;
        else
            yPos = lane_config_source(j,i) * 10;
        end
%         image('CData',img,'XData', [xPos - models{j,6}.L xPos],'YData',[yPos-1 yPos+1],'AlphaData', alphachannel);
        rectangle('Position',[xPos-models{j,6}.L yPos-1 models{j,6}.L 2])
        textToWrite = [num2str(identifiers(j)) ' ' num2str(velocities(j,i)*3.6,2)];
        text(xPos-models{j,6}.L + 0.1, yPos, textToWrite)
    end
    legend(cellstr(num2str(t(i))));
    writeVideo(v,getframe);
end
close(v);