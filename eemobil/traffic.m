global latest_lane_changes_start latest_lane_changes_end target_line

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
i = 1;
t(1) = 0;

%% Solving
disp(['Simulation'])
% run the simulation until the last car will reach the target line
while min(y(1:2:end,i)) < target_line
    t(i+1) = t(i) + dt;
    if max(y(1:2:end,i)) > target_line && ~first_car_reached_the_target_line
        first_car_reached_the_target_line = true;
        %disp(['First driver reached his target line at: ' num2str(t(i))])
    end

    [dy, next_source_lanes, next_target_lanes, next_states_of_cars] = lanes(t(i), y(:,i), lane_config_source(:,i), lane_config_target(:,i));
    y(:,i+1) = y(:,i) + dt * dy;

    lane_config_source(:,i+1) = next_source_lanes;
    lane_config_target(:,i+1) = next_target_lanes;
    states_of_cars(:,i+1) = next_states_of_cars;
    
    i = i + 1;
end

disp(['Time:'  num2str(t(length(t)))])