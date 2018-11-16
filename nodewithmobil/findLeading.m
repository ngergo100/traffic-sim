function [position_leading, velocity_leading] = findLeading(y, lane_numbers, current_car)

positions = y(1:2:end);
velocities = y(2:2:end);

p_my_car = positions(current_car);
v_my_car = velocities(current_car);
l_my_car = lane_numbers(current_car);

position_indices_in_same_lane = find(lane_numbers == l_my_car);
positions_in_my_lane = positions(position_indices_in_same_lane);

position_leading = 0;
velocity_leading = 0;

end