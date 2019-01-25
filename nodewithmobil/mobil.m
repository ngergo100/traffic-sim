function ret = mobil(params, t)
if params.a_n_left(2) > -params.b_max_left && params.a_c_left(2) > params.a_c(2)
    disp(['Lane change to left at time: ' num2str(t)])
    ret.a_c = params.a_c;
    ret.chosen_lane = params.left_lane;
elseif params.a_n_right(2) > -params.b_max_right && params.a_c_right(2) > params.a_c(2)
    disp(['Lane change to right at time: ' num2str(t)])
    ret.a_c = params.a_c;
    ret.chosen_lane = params.right_lane;
else
    ret.a_c = params.a_c;
    ret.chosen_lane = params.current_lane;
end
end

