function lane_count = prepare_lane_count(possible_lane_numbers, lane_config)
    for i=1:length(possible_lane_numbers)
        for j=1:size(lane_config, 2)
            lane_count(i,j) = length(lane_config(possible_lane_numbers(i)==lane_config(:,j)));
        end
    end

end

