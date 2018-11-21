function [position_leading, velocity_leading] = find_leading(sorted_traffic, current_car_data, lane)

position_indices_in_same_lane = find((sorted_traffic(:,3) == lane) | (sorted_traffic(:,4) == current_car_data(4)));
traffic_in_my_lane = sorted_traffic(position_indices_in_same_lane,:);
my_index = find(traffic_in_my_lane(:,1) == current_car_data(1) & traffic_in_my_lane(:,2) == current_car_data(2) & traffic_in_my_lane(:,3) == current_car_data(3));

if size(traffic_in_my_lane, 1) > my_index
    leading_car_data = traffic_in_my_lane(my_index + 1,:);
    position_leading = leading_car_data(1);
    velocity_leading = leading_car_data(2);
else
    position_leading = 0;
    velocity_leading = 0;
end

end