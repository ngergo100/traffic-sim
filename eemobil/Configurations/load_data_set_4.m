global models possible_lane_numbers weighted_average_acceleration_calculation_enabled target_line

models = {
     01, 1, 0, 0, 0/3.6, IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',53/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L',4.2, 'time_to_change_lane',1, 'lane_change_duration',2.0, 'not_paying_attention',[24,26],  'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.3, 'p',0));
     02, 2, 0, 0, 0/3.6, IDModel(struct('a_max',1.4, 'b_max',2, 'v_0',52/3.6, 'T',1.8, 'h_0',1.1, 'delta',4, 'L',4.4, 'time_to_change_lane',1, 'lane_change_duration',2.5, 'not_paying_attention',[0,2],    'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.2, 'p',0));
     03, 1, 0, 0, 0/3.6, IDModel(struct('a_max',0.8, 'b_max',2, 'v_0',55/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L', 4.2, 'time_to_change_lane',1, 'lane_change_duration',4.0, 'not_paying_attention',[10,12], 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.01, 'p',0));
     04, 2, 0, 0, 0/3.6, IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',53/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L',4.2, 'time_to_change_lane',1, 'lane_change_duration',2.0, 'not_paying_attention',[24,26],  'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.3, 'p',0));
     05, 1, 0, 0, 0/3.6, IDModel(struct('a_max',1.4, 'b_max',2, 'v_0',52/3.6, 'T',1.8, 'h_0',1.1, 'delta',4, 'L',4.4, 'time_to_change_lane',1, 'lane_change_duration',2.5, 'not_paying_attention',[0,2],    'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.2, 'p',0));
     06, 2, 0, 0, 0/3.6, IDModel(struct('a_max',0.8, 'b_max',2, 'v_0',55/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L', 4.2, 'time_to_change_lane',1, 'lane_change_duration',4.0, 'not_paying_attention',[10,12], 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.01, 'p',0));
};

% Auto positioning
for i=1:size(models, 1)
   [leading_car_back, found_previous] = find_previous_in_lane(i);
   
   if found_previous 
       models{i,4} = leading_car_back - models{i,6}.h_0;
   else
       models{i,4} = 0;
   end
   
end

weighted_average_acceleration_calculation_enabled = true;
possible_lane_numbers = [1;2];
target_line = 20;
dt = 0.1;