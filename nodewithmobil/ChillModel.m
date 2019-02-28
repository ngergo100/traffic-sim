classdef ChillModel
    properties
        b_max = 1.67;
        L = 4.5
        time_to_change_lane = 2
        lane_change_duration = 2
        not_paying_attention = []
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