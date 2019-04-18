function dataset_helper(driver, index)
    global models
    %models{index,6} = driver;
    
    models{index,6}.time_to_change_lane = driver.time_to_change_lane;
    models{index,6}.lane_change_duration = driver.lane_change_duration;
    models{index,6}.not_paying_attention = driver.not_paying_attention;
    models{index,6}.acceleration_threshold = driver.acceleration_threshold;
    models{index,6}.acceleration_difference_threshold = driver.acceleration_difference_threshold;
end

