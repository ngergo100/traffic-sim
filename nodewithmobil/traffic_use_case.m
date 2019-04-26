clc
close all
clear

addpath('./Configurations')
should_use_images = false;
load_data_set_1

%driver = IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.2, 'time_to_change_lane',1, 'lane_change_duration',2.0, 'not_paying_attention',[], 'acceleration_threshold',10, 'acceleration_difference_threshold',0.3));

%dataset_helper(driver,7)

traffic
    
post_processing
    
animation