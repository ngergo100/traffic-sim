function ret = mobil(params)
if params.a_n_left > -params.b_max_left & params.a_c_left > params.a_c
    disp('Lane change to left')
    ret.a_c = params.a_c;
    ret.chosen_lane = params.left_lane;
elseif params.a_n_right > -params.b_max_right & params.a_c_right > params.a_c
    disp('Lane change to right')
    ret.a_c = params.a_c;
    ret.chosen_lane = params.right_lane;
else
    ret.a_c = params.a_c;
    ret.chosen_lane = params.current_lane;
end
end

