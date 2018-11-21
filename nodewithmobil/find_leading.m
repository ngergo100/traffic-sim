function [position_leading, velocity_leading] = find_leading(y, lane_numbers, current_car)

% positions, velocities, lane_numbers
traffic = [y(1:2:end), y(2:2:end), lane_numbers];
current_car_data = traffic(current_car,:);
sorted_traffic = sortrows(traffic);

position_indices_in_same_lane = find(sorted_traffic(:,3) == current_car_data(3));
traffic_in_my_lane = sorted_traffic(position_indices_in_same_lane,:);
my_index = find(traffic_in_my_lane(:,1) == current_car_data(1) & traffic_in_my_lane(:,2) == current_car_data(2));

if size(traffic_in_my_lane, 1) > my_index
    leading_car_data = traffic_in_my_lane(my_index + 1,:);
    position_leading = leading_car_data(1);
    velocity_leading = leading_car_data(2);
else
    position_leading = 0;
    velocity_leading = 0;
end

end