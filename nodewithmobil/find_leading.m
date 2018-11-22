function car = find_leading(sorted_traffic, current_car_data, lane)

traffic_in_my_lane = sorted_traffic((sorted_traffic(:,3) == lane) | (sorted_traffic(:,4) == current_car_data(4)),:);
my_index = find(traffic_in_my_lane(:,4) == current_car_data(4));

if size(traffic_in_my_lane, 1) > my_index
    leading_car_data = traffic_in_my_lane(my_index + 1,:);
    car = struct('position', leading_car_data(1),'velocity', leading_car_data(2), 'identifier',leading_car_data(4));
else
    car = struct('position',0,'velocity',0,'identifier',0);
end

end