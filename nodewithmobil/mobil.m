function ret = mobil(params, t)
if params.a_n_left(2) > -params.b_max_left && params.a_c_left(2) > params.a_c(2) && params.current_position - params.length >= params.current_position_left_car
    disp(['Lane change to left at time: ' num2str(t)])
    %% TODO a_c_left
    ret.a_c = params.a_c;
    ret.chosen_lane = params.left_lane;
elseif params.a_n_right(2) > -params.b_max_right && params.a_c_right(2) > params.a_c(2) && params.current_position - params.length >= params.current_position_right_car
    disp(['Lane change to right at time: ' num2str(t)])
    %% TODO a_c_right
    ret.a_c = params.a_c;
    ret.chosen_lane = params.right_lane;
else
    ret.a_c = params.a_c;
    ret.chosen_lane = params.current_lane;
end
end

