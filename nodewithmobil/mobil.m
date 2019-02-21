function ret = mobil(params, t)

desirable_change_to_left = params.a_c_left(2) > params.a_c(2);
desirable_change_to_right = params.a_c_right(2) > params.a_c(2);

if params.safe_change_to_left && desirable_change_to_left && params.can_change_to_left
    disp(['Lane change to left at time: ' num2str(t)])
    ret.a_c = params.a_c_left;
    ret.chosen_lane = params.left_lane;
elseif params.safe_change_to_right && desirable_change_to_right && params.can_change_to_right
    disp(['Lane change to right at time: ' num2str(t)])
    ret.a_c = params.a_c_right;
    ret.chosen_lane = params.right_lane;
else
    ret.a_c = params.a_c;
    ret.chosen_lane = params.current_lane;
end
end

