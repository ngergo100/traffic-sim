%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
clc
close all
clear

addpath('./Configurations')

config_count = 10;
changed_cars_count = 10;

for variation_config_index=1:changed_cars_count
    
variations = nchoosek(1:config_count, variation_config_index);

for index=1:size(variations,1)
    should_use_images = false;
    
    load_data_set_1
    
    actual_variation = variations(index,:);
    
    for i=1:length(actual_variation)
        driver = IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.2, 'time_to_change_lane',1, 'lane_change_duration',2.0, 'not_paying_attention',[], 'acceleration_threshold',10, 'acceleration_difference_threshold',0.3, 'p',0));

        dataset_helper(driver, actual_variation(i))
    end

    traffic
    
    times(index,variation_config_index) = t(length(t));
    
    fprintf(['Progress of variation: ' num2str(index) '/' num2str(size(variations,1)) '\nProgress of varitaions: ' num2str(variation_config_index) '/' num2str(changed_cars_count) '\n'])
    
    clearvars -except config_count changed_cars_count variations times variation_config_index
end

end

for i=1:size(times,2)
    hold all;
    timetable = nonzeros(times(:,i));
    plot(i*ones(1,length(timetable)),timetable, 'x')
end
