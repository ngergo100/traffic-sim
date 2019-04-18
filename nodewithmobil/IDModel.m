classdef IDModel
    properties
        a_max
        b_max
        v_0
        T
        h_0
        delta
        L
        time_to_change_lane
        lane_change_duration
        not_paying_attention
        acceleration_threshold
        acceleration_difference_threshold
    end
    methods
        function obj = IDModel(consts)
            obj.a_max = consts.a_max; 
            obj.b_max = consts.b_max;
            obj.v_0 = consts.v_0;
            obj.T = consts.T;
            obj.h_0 = consts.h_0;
            obj.delta = consts.delta;
            obj.L = consts.L;
            obj.time_to_change_lane = consts.time_to_change_lane;
            obj.lane_change_duration = consts.lane_change_duration;
            obj.not_paying_attention = consts.not_paying_attention;
            obj.acceleration_threshold = consts.acceleration_threshold;
            obj.acceleration_difference_threshold = consts.acceleration_difference_threshold;
        end
        function dy = next_step(obj, ~, y, leading_car)
            if leading_car.identifier ~= 0
                h_star = obj.h_0 + y(2) * obj.T  + (y(2) * (y(2) - leading_car.velocity)) / (2 * sqrt(obj.a_max * obj.b_max));
                h = leading_car.position - leading_car.L - y(1);
                dy = [
                    y(2);
                    obj.a_max * (1 - (y(2) / obj.v_0)^obj.delta - (h_star / h)^2)
                ];
            else
                dy = [
                    y(2);
                    obj.a_max * (1 - (y(2) / obj.v_0)^obj.delta)
                ];
            end
        end
    end
end