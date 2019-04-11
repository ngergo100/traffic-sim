function load_data_set_3
global models possible_lane_numbers weighted_average_acceleration_calculation_enabled target_line

models = {
     01, 1, 0, 0,    0/3.6, IDModel(struct('a_max',2.5, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',2, 'not_paying_attention',[], 'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.3));
     02, 2, 0, 0,    0/3.6, IDModel(struct('a_max',2.2, 'b_max',2, 'v_0',45/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',3, 'not_paying_attention',[], 'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.2));
     03, 1, 0, -6,   0/3.6, IDModel(struct('a_max',0.8, 'b_max',2, 'v_0',40/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L', 20, 'time_to_change_lane',1, 'lane_change_duration',4, 'not_paying_attention',[], 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.3));
     04, 2, 0, -6,   0/3.6, IDModel(struct('a_max',4.5, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',3, 'not_paying_attention',[], 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.4));
     05, 1, 0, -27.5,0/3.6, IDModel(struct('a_max',2.1, 'b_max',2, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',2, 'not_paying_attention',[], 'acceleration_threshold',1.6, 'acceleration_difference_threshold',0.3));
     06, 2, 0, -12,  0/3.6, IDModel(struct('a_max',4.2, 'b_max',2, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',3, 'not_paying_attention',[], 'acceleration_threshold',1.6, 'acceleration_difference_threshold',0.2));
     07, 1, 0, -33.5,  0/3.6, IDModel(struct('a_max',3.4, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',4, 'not_paying_attention',[], 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.35));
     08, 2, 0, -19,  0/3.6, IDModel(struct('a_max',4.5, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',3, 'not_paying_attention',[], 'acceleration_threshold',1.1, 'acceleration_difference_threshold',0.34));
     09, 1, 0, -39.5,  0/3.6, IDModel(struct('a_max',2.5, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',2, 'not_paying_attention',[], 'acceleration_threshold',1.3, 'acceleration_difference_threshold',0.3));
     10, 2, 0, -25,  0/3.6, IDModel(struct('a_max',3.2, 'b_max',2, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.5, 'time_to_change_lane',1, 'lane_change_duration',4, 'not_paying_attention',[], 'acceleration_threshold',1.7, 'acceleration_difference_threshold',0.3));
};

weighted_average_acceleration_calculation_enabled = true;
possible_lane_numbers = [1;2];
target_line = 100;

end