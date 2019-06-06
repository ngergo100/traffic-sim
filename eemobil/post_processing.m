%% Post processing
disp(['Post proceessing'])
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