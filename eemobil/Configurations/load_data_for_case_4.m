global models possible_lane_numbers weighted_average_acceleration_calculation_enabled target_line

models = {
     01, 1, 0, 0, 0/3.6, IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',53/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L',4.2, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[24,26]             , 'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.3 , 'p',0, 'stops',false));
     02, 2, 0, 0, 0/3.6, IDModel(struct('a_max',1.4, 'b_max',2, 'v_0',52/3.6, 'T',1.8, 'h_0',1.1, 'delta',4, 'L',4.4, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[0,2]               , 'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.2 , 'p',0, 'stops',false));
     03, 1, 0, 0, 0/3.6, IDModel(struct('a_max',0.8, 'b_max',2, 'v_0',55/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L', 20, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[10,12]             , 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.01, 'p',0, 'stops',false));
     04, 2, 0, 0, 0/3.6, IDModel(struct('a_max',2.0, 'b_max',3, 'v_0',53/3.6, 'T',1.8, 'h_0',1.1, 'delta',4, 'L',4.1, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[0,3;22,24;25,25.5] , 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.4 , 'p',0, 'stops',false));
     05, 1, 0, 0, 0/3.6, IDModel(struct('a_max',2.1, 'b_max',2, 'v_0',49/3.6, 'T',1.8, 'h_0',1.0, 'delta',4, 'L',4.3, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[15,19]             , 'acceleration_threshold',1.6, 'acceleration_difference_threshold',1.3 , 'p',0, 'stops',false));
     06, 2, 0, 0, 0/3.6, IDModel(struct('a_max',2.0, 'b_max',2, 'v_0',55/3.6, 'T',1.8, 'h_0',1.3, 'delta',4, 'L',4.5, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[15,16.5]           , 'acceleration_threshold',1.6, 'acceleration_difference_threshold',0.2 , 'p',0, 'stops',false));
     07, 1, 0, 0, 0/3.6, IDModel(struct('a_max',2.4, 'b_max',3, 'v_0',52/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L',4.6, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[0,2]               , 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.35, 'p',0, 'stops',false));
     08, 2, 0, 0, 0/3.6, IDModel(struct('a_max',3.0, 'b_max',3, 'v_0',53/3.6, 'T',1.8, 'h_0',1.1, 'delta',4, 'L',4.1, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[]                  , 'acceleration_threshold',1.1, 'acceleration_difference_threshold',0.34, 'p',0, 'stops',false));
     09, 1, 0, 0, 0/3.6, IDModel(struct('a_max',1.0, 'b_max',9, 'v_0',55/3.6, 'T',1.8, 'h_0',1.2, 'delta',4, 'L',4.3, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[0,3]               , 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.3 , 'p',0, 'stops',false));
     10, 2, 0, 0, 0/3.6, IDModel(struct('a_max',2.2, 'b_max',2, 'v_0',52/3.6, 'T',1.8, 'h_0',1.1, 'delta',4, 'L',4.4, 'time_to_change_lane',0, 'lane_change_duration',0, 'not_paying_attention',[0,4;15,18.5]       , 'acceleration_threshold',1.7, 'acceleration_difference_threshold',0.3 , 'p',0, 'stops',false));
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

weighted_average_acceleration_calculation_enabled = false;
possible_lane_numbers = [1;2];
target_line = 100;
dt = 0.01;
