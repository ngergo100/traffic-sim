function dy = lanes(t, y, models)

lane_numbers = cat(1, models{:,5});
identifiers = cat(1, models{:,1});
traffic = [y(1 : 2 : end), y(2 : 2 : end), lane_numbers, identifiers];
sorted_traffic = sortrows(traffic);
reverse_sorted = flipud(sorted_traffic);

for i=1:size(models, 1)
  current_car_data = traffic(i,:);
  
  possible_left_lane = current_car_data(3) - 1;
  possible_right_lane = current_car_data(3) + 1;
  left_lane = ismember(possible_left_lane, lane_numbers) * possible_left_lane;
  right_lane = ismember(possible_right_lane, lane_numbers) * possible_right_lane;
  
  [leading_car_position, leading_car_velocity] = find_leading(sorted_traffic, current_car_data, current_car_data(3));
  if left_lane ~= 0 
      [left_leading_car_position, left_leading_car_velocity] = find_leading(sorted_traffic, current_car_data, left_lane);
      [left_following_car_position, left_following_car_velocity] = find_leading(reverse_sorted, current_car_data, left_lane);
  end
  
  if right_lane ~=0
      [right_leading_car_position, right_leading_car_velocity] = find_leading(sorted_traffic, current_car_data, right_lane);
      [right_following_car_position, right_following_car_velocity] = find_leading(reverse_sorted, current_car_data, right_lane);
  end
  
  dy_ith = models{i, 4}.next_step(t, [current_car_data(1); current_car_data(2)], leading_car_position, leading_car_velocity);
  dy(2*i-1)= dy_ith(1);
  dy(2*i)= dy_ith(2);
end

dy = dy';

end