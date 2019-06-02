classdef ChillModel
    properties
        a_max
        b_max = 1.67;
        v_0
        T
        h_0
        delta
        L = 4.5;
        time_to_change_lane = 2
        lane_change_duration = 2
        not_paying_attention = []
        acceleration_threshold
        acceleration_difference_threshold
        p
    end
    
    methods
        function dy = next_step(~, ~, y, ~)
            dy = [
                y(2);
                0
                ];
        end
    end
end