function [dy, next_source_lane_numbers, next_target_lane_numbers, states_of_cars] = lanes(t, y, source_lane_numbers, target_lane_numbers)

global models possible_lane_numbers latest_lane_changes_start latest_lane_changes_end weighted_average_acceleration_calculation_enabled

%% Initial settings
% Get identifiers for all cars
identifiers = cat(1, models{:, 1});
% Get lengths for all cars
lengths = arrayfun(@(a) a.L, cat(1, models{:, 6}));
% Create a matrix with positions, velocities, source lanes, target lanes,
% ids and lengths at a given t
traffic = [y(1 : 2 : end), y(2 : 2 : end), source_lane_numbers, target_lane_numbers, identifiers, lengths];
% Sort traffic matrix based on the position
sorted_traffic = sortrows(traffic);
% Create an empty array for the next loop's source lanes
next_source_lane_numbers = zeros(length(source_lane_numbers), 1);
% Create an empty array for the next loop's target lanes
next_target_lane_numbers = zeros(length(target_lane_numbers), 1);
% Create an empty array for the next loop states of cars
states_of_cars = zeros(length(source_lane_numbers), 1);

clear dy
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
  mobil_params.acceleration_threshold = models{i, 6}.acceleration_threshold;
  mobil_params.acceleration_difference_threshold = models{i, 6}.acceleration_difference_threshold;
  mobil_params.p = models{i, 6}.p;
  
  % Find current car's leader
  current_leading_car = find_leading(sorted_traffic, current_car_data, current_car_data(3));
  % Find current car's follower
  current_following_car = find_following(sorted_traffic, current_car_data, current_car_data(3));
  if current_following_car.identifier ~= 0
     current_following_car_index = find(traffic(:,5) == current_following_car.identifier);
     mobil_params.a_o = models{current_following_car_index, 6}.next_step(t, [current_following_car.position; current_following_car.velocity], struct('position', current_car_data(1), 'velocity', current_car_data(2), 'identifier',current_car_data(5), 'L',current_car_data(6)));
     mobil_params.a_o_possible = models{current_following_car_index, 6}.next_step(t, [current_following_car.position; current_following_car.velocity], current_leading_car);
  else
     mobil_params.a_o = [0,0];
     mobil_params.a_o_possible = [0,0];
  end

  % Calculate what would happen if current car would go straight behind its
  % leader
  paying_attention = is_paying_attention_at_the_moment(models{i,6}.not_paying_attention, t);
  if paying_attention
      mobil_params.a_c = models{i, 6}.next_step(t, [current_car_data(1); current_car_data(2)], current_leading_car);
  else
      states_of_cars(i) = 3;
      mobil_params.a_c = [current_car_data(2), 0];
  end
  
  if ~paying_attention
      %disp(['Number ' num2str(current_car_data(5)) ' driver is not paying attantion at moment: ' num2str(t)])
  end
  
  %mobil_params.current_position = current_car_data(1);
  
  % if the ith target lane is 0, which means ith car isn't 
  % changing lanes currently and time_to_change_lane parameter allows the
  % lane change and ith car's driver is paying attention
  if target_lane_numbers(i) == 0 && latest_lane_changes_end(i) + models{i, 6}.time_to_change_lane <= t && paying_attention
    % If a left lane exist
    if mobil_params.left_lane ~= 0
      % Find current car's leader if it would in the left lane
      left_leading_car = find_leading(sorted_traffic, current_car_data, mobil_params.left_lane);
      % Calculate what would happen if current car would go straight behind
      % its left leader
      mobil_params.a_c_left = models{i, 6}.next_step(t, [current_car_data(1); current_car_data(2)], left_leading_car);
      left_following_car = find_following(sorted_traffic, current_car_data, mobil_params.left_lane);
      if left_following_car.identifier ~=0
        left_following_car_index = find(traffic(:,5) == left_following_car.identifier);
        left_following_car_model = models{left_following_car_index, 6};
        mobil_params.a_n_left = left_following_car_model.next_step(t, [left_following_car.position; left_following_car.velocity], struct('position', current_car_data(1), 'velocity', current_car_data(2), 'identifier',current_car_data(5), 'L',current_car_data(6)));
        mobil_params.a_n_left_possible = left_following_car_model.next_step(t, [left_following_car.position; left_following_car.velocity], left_leading_car);
        mobil_params.safe_change_to_left = mobil_params.a_n_left(2) > -models{left_following_car_index, 6}.b_max && current_car_data(1) - current_car_data(6) >= left_following_car.position;
      else 
        mobil_params.safe_change_to_left = true;
        mobil_params.a_n_left = [0,0];
        mobil_params.a_n_left_possible = [0,0];
      end
      if left_leading_car.identifier ~=0
        mobil_params.can_change_to_left = left_leading_car.position - left_leading_car.L >= current_car_data(1);
      else
        mobil_params.can_change_to_left = true;
      end
   else 
     mobil_params.a_c_left = [0,0];
     mobil_params.safe_change_to_left = false;
     mobil_params.can_change_to_left = false;
     mobil_params.a_n_left = [0,0];
     mobil_params.a_n_left_possible = [0,0];
   end
  
  % If a right lane exist
   if mobil_params.right_lane ~=0
      % Find current car's leader if it would in the right lane
      right_leading_car = find_leading(sorted_traffic, current_car_data, mobil_params.right_lane);
      % Calculate what would happen if current car would go straight behind
      % its right leader
      mobil_params.a_c_right = models{i, 6}.next_step(t, [current_car_data(1); current_car_data(2)], right_leading_car);
      right_following_car = find_following(sorted_traffic, current_car_data, mobil_params.right_lane);
      if right_following_car.identifier ~=0
        right_following_car_index = find(traffic(:,5) == right_following_car.identifier);
        right_following_car_model = models{right_following_car_index, 6};
        mobil_params.a_n_right = right_following_car_model.next_step(t, [right_following_car.position; right_following_car.velocity], struct('position', current_car_data(1),'velocity', current_car_data(2), 'identifier',current_car_data(5), 'L',current_car_data(6)));
        mobil_params.a_n_right_possible = right_following_car_model.next_step(t, [right_following_car.position; right_following_car.velocity], right_leading_car);
        mobil_params.safe_change_to_right = mobil_params.a_n_right(2) > -models{right_following_car_index, 6}.b_max && current_car_data(1) - current_car_data(6) >= right_following_car.position;
      else 
        mobil_params.safe_change_to_right = true;
        mobil_params.a_n_right = [0,0];
        mobil_params.a_n_right_possible = [0,0];
      end
      if right_leading_car.identifier ~=0
        mobil_params.can_change_to_right = right_leading_car.position - right_leading_car.L >= current_car_data(1);
      else
        mobil_params.can_change_to_right = true;
      end
   else 
      mobil_params.a_c_right = [0,0];
      mobil_params.safe_change_to_right = false;
      mobil_params.can_change_to_right = false;
      mobil_params.a_n_right = [0,0];
      mobil_params.a_n_right_possible = [0,0];
   end
  
    chosen_direction = mobil(mobil_params, t);
    if chosen_direction.paying_attention_to_lane_change
        states_of_cars(i) = 1;
    end
    % if chosen lane is not the current lane then save the start of 
    if mobil_params.current_lane ~= chosen_direction.chosen_lane
      latest_lane_changes_start(i) = t;
      %disp(['Number ' num2str(current_car_data(5)) ' driver started his lane change at time: ' num2str(t)])
      next_source_lane_numbers(i) = mobil_params.current_lane;
      next_target_lane_numbers(i) = chosen_direction.chosen_lane;
    else
      next_source_lane_numbers(i) = mobil_params.current_lane;
      next_target_lane_numbers(i) = 0;
    end

    dy(2*i-1)= chosen_direction.a_c(1);
    dy(2*i)= chosen_direction.a_c(2);
  
 else % if target_lane_numbers(i) not 0 or she/he does not want to change yet
     
    if latest_lane_changes_start(i) + models{i, 6}.lane_change_duration <= t && target_lane_numbers(i) ~= 0 
        latest_lane_changes_end(i) = t;
        %disp(['Number ' num2str(current_car_data(5)) ' driver ended his lane change at time: ' num2str(t)])
        next_source_lane_numbers(i) = target_lane_numbers(i);
        next_target_lane_numbers(i) = 0;
    else
        next_source_lane_numbers(i) = source_lane_numbers(i);
        next_target_lane_numbers(i) = target_lane_numbers(i);
    end 
    
    if latest_lane_changes_start(i) + models{i, 6}.lane_change_duration > t && target_lane_numbers(i) ~= 0
        %disp(['Number ' num2str(current_car_data(5)) ' driver is changing lanes at t: ' num2str(t)])
        states_of_cars(i) = 2;
        
        if weighted_average_acceleration_calculation_enabled
            start = latest_lane_changes_start(i);
            duration = models{i, 6}.lane_change_duration;
            unit_elapsed_time = (t - latest_lane_changes_start(i)) / duration;
            unit_remaining_time = (start + duration - t) / duration;
            %disp(['unit_elapsed_time ' num2str(unit_elapsed_time)])
            %disp(['unit_remaining_time ' num2str(unit_remaining_time)])
            if target_lane_numbers(i) == mobil_params.right_lane
                dy(2*i-1) = mobil_params.a_c(1) * unit_remaining_time + mobil_params.a_c_right(1) * unit_elapsed_time;
                dy(2*i) = mobil_params.a_c(2) * unit_remaining_time + mobil_params.a_c_right(2) * unit_elapsed_time;
            elseif target_lane_numbers(i) == mobil_params.left_lane
                dy(2*i-1) = mobil_params.a_c(1) * unit_remaining_time + mobil_params.a_c_left(1) * unit_elapsed_time;
                dy(2*i) = mobil_params.a_c(2) * unit_remaining_time + mobil_params.a_c_left(2) * unit_elapsed_time;
            else
                dy(2*i-1) = mobil_params.a_c(1);
                dy(2*i) = mobil_params.a_c(2);
            end
        else
            dy(2*i-1) = mobil_params.a_c(1);
            dy(2*i) = mobil_params.a_c(2);
        end
    else
        dy(2*i-1) = mobil_params.a_c(1);
        dy(2*i) = mobil_params.a_c(2);
    end
    
  end
  
  if dy(2*i-1) <= 0 && dy(2*i) < 0
      dy(2*i-1) = mobil_params.a_c(1);
      dy(2*i) = 0;
  else
      dy(2*i-1) = mobil_params.a_c(1);
      dy(2*i) = mobil_params.a_c(2);
  end
end

dy = dy';

end