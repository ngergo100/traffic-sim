clc
clear
close all

addpath('./Configurations')
should_use_images = false;
global models possible_lane_numbers latest_lane_changes_start latest_lane_changes_end target_line
%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
load_data_set_1;

%% Initialization
lane_config_source = cat(1, models{:,2});
lane_config_target = cat(1, models{:,3});
latest_lane_changes_start = zeros(length(lane_config_target),1);
latest_lane_changes_end = zeros(length(lane_config_source),1);
states_of_cars = zeros(length(lane_config_source),1);
for i=1:size(models, 1)
   y0(2*i-1) = models{i,4};
   y0(2*i) = models{i,5};
end
y0 = y0';
y = y0;
first_car_reached_the_target_line = false;

% Time initialization
t0 = 0;
dt = 0.1;
i = 1;
t(1) = 0;

%% Solving
% run the simulation until the last car will reach the target line
while min(y(1:2:end,i)) < target_line
    t(i+1) = t(i) + dt;
    if max(y(1:2:end,i)) > target_line && ~first_car_reached_the_target_line
        first_car_reached_the_target_line = true;
        disp(['First driver reached his target line at: ' num2str(t(i))])
    end

    [dy, next_source_lanes, next_target_lanes, next_states_of_cars] = lanes(t(i), y(:,i), lane_config_source(:,i), lane_config_target(:,i));
    y(:,i+1) = y(:,i) + dt * dy;

    lane_config_source(:,i+1) = next_source_lanes;
    lane_config_target(:,i+1) = next_target_lanes;
    states_of_cars(:,i+1) = next_states_of_cars;
    
    i = i + 1;
end

disp(['Post proceessing'])

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

disp(['Animation'])
%% Animation
v = VideoWriter('video','MPEG-4');
v.Quality = 50;
open(v);
ratio = 600/1200;
width = 1200;
fig = figure('Renderer', 'painters', 'Position', [0 0 width width*ratio]);
[img_car, map_car, alphachannel_car] = imread('Pics/bugattismall.png');
[img_bus, map_bus, alphachannel_bus] = imread('Pics/bus.png');
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
            yPos = (lane_config_source(j,i) + (lane_config_target(j,i) - lane_config_source(j,i)) * easeinout(elapsed_steps, 2)) * 10;
        else
            yPos = lane_config_source(j,i) * 10;
        end
        if should_use_images
            if models{j,6}.L > 10 
                image('CData',img_bus,'XData', [xPos - models{j,6}.L xPos],'YData',[yPos-1 yPos+1],'AlphaData', alphachannel_bus);
            else
                image('CData',img_car,'XData', [xPos - models{j,6}.L xPos],'YData',[yPos-1 yPos+1],'AlphaData', alphachannel_car);
            end
        else
            r = rectangle('Position',[xPos-models{j,6}.L yPos-1 models{j,6}.L 2]);
            if states_of_cars(j,i) == 1
                r.FaceColor = [0 1 0];
            elseif states_of_cars(j,i) == 2
                r.FaceColor = [0 0 1];
            elseif states_of_cars(j,i) == 3
                r.FaceColor = [1 0 0];
            end
            textToWrite = [num2str(identifiers(j)) ' ' num2str(velocities(j,i)*3.6,2)];
            text(xPos-models{j,6}.L + 0.1, yPos, textToWrite)
        end

    end
    legend(cellstr(num2str(t(i))));
    writeVideo(v,getframe);
end
close(v);
disp(['Animation done'])