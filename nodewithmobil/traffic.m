clc
clear
close all

%% Define the model
% parameters in models
% id, lane, initial position, initial velocity, ACC model
global models possible_lane_numbers latest_lane_changes
models = {
     11, 1, 0, 100/3.6, ChillModel;
     22, 1, -100, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',120/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
     33, 1, -200, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',120/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
     44, 1, -300, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
     55, 1, -400, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',120/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
     66, 1, -500, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
     77, 1, -600, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
     88, 1, -700, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L', 4.5, 'time_to_change_lane', 2));
};
lane_config = cat(1, models{:,2});
latest_lane_changes = zeros(length(lane_config),1);
possible_lane_numbers = [1;2;3];

%% Initialization
for i=1:size(models, 1)
   y0(2*i-1) = models{i,3};
   y0(2*i) = models{i,4};
end
y0 = y0';
y = y0;

% Time initialization
t0 = 0;
T = 50;
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
ratio = 150/1200;
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
            plot([path path+5],[(possible_lane_numbers(j)+0.5)*10 (possible_lane_numbers(j)+0.5)*10],'b');
            path = path + 8;
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
        yPos = lane_config(j,i)*10;
        image('CData',img,'XData', [xPos - models{j,5}.L xPos],'YData',[yPos-1 yPos+1],'AlphaData', alphachannel);        
        text(xPos, yPos, num2str(identifiers(j)))
    end
    writeVideo(v,getframe);
end
close(v);