function [dy, next_lane_numbers] = lanes(t, y, lane_numbers)

global models possible_lane_numbers

%% Initial settings
% Get identifiers for all cars
identifiers = cat(1, models{:,1}); 
% Create matrix with position, velocity, current lane and ids at a given t
traffic = [y(1 : 2 : end), y(2 : 2 : end), lane_numbers, identifiers];
% Sort traffic matrix based on the position
sorted_traffic = sortrows(traffic);
% Reverse sort traffic matrix based on the position
reverse_sorted_traffic = flipud(sorted_traffic);
% Create an empty array for the next loops initial lanes
next_lane_numbers = zeros(length(lane_numbers), 1);

%% Loop over all car models

for i=1:size(models, 1)
  % i-th car's position, velocity, lane and id 
  current_car_data = traffic(i,:);
  
  % Current car's left lane and right lane
  possible_left_lane = current_car_data(3) - 1;
  possible_right_lane = current_car_data(3) + 1;
  % Check if left and right lanes exist indeed (if not sign it with 0)
  mobil_params.left_lane = ismember(possible_left_lane, possible_lane_numbers) * possible_left_lane;
  mobil_params.right_lane = ismember(possible_right_lane, possible_lane_numbers) * possible_right_lane;
  mobil_params.current_lane = current_car_data(3);
  
  % Find current car's leader
  leading_car = find_leading(sorted_traffic, current_car_data, current_car_data(3));
  % Calculate what would happen if current car would go straight behind its
  % leader
  mobil_params.a_c = models{i, 5}.next_step(t, [current_car_data(1); current_car_data(2)], leading_car);
  
  % If a left lane exist
  if mobil_params.left_lane ~= 0
      % Find current car's leader if it would in the left lane
      left_leading_car = find_leading(sorted_traffic, current_car_data, mobil_params.left_lane);
      % Calculate what would happen if current car would go straight behind
      % its left leader
      mobil_params.a_c_left = models{i, 5}.next_step(t, [current_car_data(1); current_car_data(2)], left_leading_car);
      left_following_car = find_leading(reverse_sorted_traffic, current_car_data, mobil_params.left_lane);
      if left_following_car.identifier ~=0
        left_following_car_index = find(traffic(:,4) == left_following_car.identifier);
        left_following_car_model = models{left_following_car_index, 5};
        mobil_params.a_n_left = left_following_car_model.next_step(t, [left_following_car.position; left_following_car.velocity], struct('position', current_car_data(1), 'velocity', current_car_data(2), 'identifier',current_car_data(4)));
        mobil_params.b_max_left = models{left_following_car_index, 5}.b_max;
      else 
        mobil_params.a_n_left = [0,0];
        mobil_params.b_max_left = 1;
      end
  else 
     mobil_params.a_c_left = [0,0];
     mobil_params.a_n_left = [0,0];
     mobil_params.b_max_left = -1;
  end
  
  % If a right lane exist
  if mobil_params.right_lane ~=0
      % Find current car's leader if it would in the right lane
      right_leading_car = find_leading(sorted_traffic, current_car_data, mobil_params.right_lane);
      % Calculate what would happen if current car would go straight behind
      % its right leader
      mobil_params.a_c_right = models{i, 5}.next_step(t, [current_car_data(1); current_car_data(2)], right_leading_car);
      right_following_car = find_leading(reverse_sorted_traffic, current_car_data, mobil_params.right_lane);
      if right_following_car.identifier ~=0
        right_following_car_index = find(traffic(:,4) == right_following_car.identifier);
        right_following_car_model = models{right_following_car_index, 5};
        mobil_params.a_n_right = right_following_car_model.next_step(t, [right_following_car.position; right_following_car.velocity], struct('position', current_car_data(1),'velocity', current_car_data(2), 'identifier',current_car_data(4)));
        mobil_params.b_max_right = models{right_following_car_index, 5}.b_max;
      else 
        mobil_params.a_n_right = [0,0];
        mobil_params.b_max_right = 1;
      end
  else 
      mobil_params.a_c_right = [0,0];
      mobil_params.a_n_right = [0,0];
      mobil_params.b_max_right = -1;
  end
  
  chosen_direction = mobil(mobil_params, t);
  next_lane_numbers(i) = chosen_direction.chosen_lane;

  dy(2*i-1)= chosen_direction.a_c(1);
  dy(2*i)= chosen_direction.a_c(2);
end

dy = dy';

end