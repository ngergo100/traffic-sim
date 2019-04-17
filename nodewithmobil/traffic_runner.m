%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
clc
close all
clear

for index=1:9
    addpath('./Configurations')
    should_use_images = false;
    load_data_set_1

    driver = IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',53/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.2, 'time_to_change_lane',1, 'lane_change_duration',2.0, 'not_paying_attention',[24,26], 'acceleration_threshold',1.2, 'acceleration_difference_threshold',0.3));

    dataset_helper(driver,index)

    traffic
    
    clear
end

%post_processing
 
%animation