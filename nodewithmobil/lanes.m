function [dy, next_lane_numbers] = lanes(t, y, lane_numbers)
global models possible_lane_numbers
identifiers = cat(1, models{:,1});
traffic = [y(1 : 2 : end), y(2 : 2 : end), lane_numbers, identifiers];
sorted_traffic = sortrows(traffic);
reverse_sorted_traffic = flipud(sorted_traffic);
next_lane_numbers = zeros(length(lane_numbers), 1);
for i=1:size(models, 1)
  current_car_data = traffic(i,:);
  
  possible_left_lane = current_car_data(3) - 1;
  possible_right_lane = current_car_data(3) + 1;
  mobil_params.left_lane = ismember(possible_left_lane, possible_lane_numbers) * possible_left_lane;
  mobil_params.right_lane = ismember(possible_right_lane, possible_lane_numbers) * possible_right_lane;
  mobil_params.current_lane = current_car_data(3);
  
  leading_car = find_leading(sorted_traffic, current_car_data, current_car_data(3));
  mobil_params.a_c = models{i, 4}.next_step(t, [current_car_data(1); current_car_data(2)], leading_car.position, leading_car.velocity);
  if mobil_params.left_lane ~= 0 
      left_leading_car = find_leading(sorted_traffic, current_car_data, mobil_params.left_lane);
      mobil_params.a_c_left = models{i, 4}.next_step(t, [current_car_data(1); current_car_data(2)], left_leading_car.position, left_leading_car.velocity);
      left_following_car = find_leading(reverse_sorted_traffic, current_car_data, mobil_params.left_lane);
      if left_following_car.identifier ~=0
        left_following_car_index = find(traffic(:,4) == left_following_car.identifier);
        left_following_car_model = models{left_following_car_index, 4};
        mobil_params.a_n_left = left_following_car_model.next_step(t, [left_following_car.position; left_following_car.velocity], current_car_data(1), current_car_data(2));
        mobil_params.b_max_left = models{left_following_car_index, 4}.b_max;
      else 
        mobil_params.a_n_left = [0,0];
        mobil_params.b_max_left = 1;
      end
  else 
     mobil_params.a_c_left = [0,0];
     mobil_params.a_n_left = [0,0];
     mobil_params.b_max_left = -1;
  end
  
  if mobil_params.right_lane ~=0
      right_leading_car = find_leading(sorted_traffic, current_car_data, mobil_params.right_lane);
      mobil_params.a_c_right = models{i, 4}.next_step(t, [current_car_data(1); current_car_data(2)], right_leading_car.position, right_leading_car.velocity);
      right_following_car = find_leading(reverse_sorted_traffic, current_car_data, mobil_params.right_lane);
      if right_following_car.identifier ~=0
        right_following_car_index = find(traffic(:,4) == right_following_car.identifier);
        right_following_car_model = models{right_following_car_index, 4};
        mobil_params.a_n_right = right_following_car_model.next_step(t, [right_following_car.position; right_following_car.velocity],current_car_data(1), current_car_data(2));
        mobil_params.b_max_right = models{right_following_car_index, 4}.b_max;
      else 
        mobil_params.a_n_right = [0,0];
        mobil_params.b_max_right = 1;
      end
  else 
      mobil_params.a_c_right = [0,0];
      mobil_params.a_n_right = [0,0];
      mobil_params.b_max_right = -1;
  end
  
  chosen_direction = mobil(mobil_params);
  next_lane_numbers(i) = chosen_direction.chosen_lane;

  dy(2*i-1)= chosen_direction.a_c(1);
  dy(2*i)= chosen_direction.a_c(2);
end

dy = dy';

end