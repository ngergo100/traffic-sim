function ret = mobil(params, t)
    paying_attention_to_lane_change = abs(params.a_c(2)) < params.acceleration_threshold;
    ret.paying_attention_to_lane_change = paying_attention_to_lane_change;

    desirable_change_to_left = params.a_c_left(2) - params.a_c(2) + params.p * (params.a_o_possible(2) - params.a_o(2) + params.a_n_left_possible(2) - params.a_n_left(2)) > params.acceleration_difference_threshold;
    desirable_change_to_right = params.a_c_right(2) - params.a_c(2) + params.p * (params.a_o_possible(2) - params.a_o(2) + params.a_n_right_possible(2) - params.a_n_right(2)) > params.acceleration_difference_threshold;
    
    if params.safe_change_to_left && params.can_change_to_left && desirable_change_to_left && paying_attention_to_lane_change
        ret.a_c = params.a_c;
        ret.chosen_lane = params.left_lane;
    elseif params.safe_change_to_right && params.can_change_to_right && desirable_change_to_right && paying_attention_to_lane_change
        ret.a_c = params.a_c;
        ret.chosen_lane = params.right_lane;
    else
        ret.a_c = params.a_c;
        ret.chosen_lane = params.current_lane;
    end
end

