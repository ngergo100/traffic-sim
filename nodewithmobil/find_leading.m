function car = find_leading(sorted_traffic, current_car_data, source_lane)

traffic_in_my_lane = sorted_traffic((sorted_traffic(:,3) == source_lane) | (sorted_traffic(:,4) == source_lane) | (sorted_traffic(:,5) == current_car_data(5)),:);
my_index = find(traffic_in_my_lane(:,5) == current_car_data(5));

if size(traffic_in_my_lane, 1) > my_index
    leading_car_data = traffic_in_my_lane(my_index + 1,:);
    car = struct('position', leading_car_data(1),'velocity', leading_car_data(2), 'identifier',leading_car_data(5));
else
    car = struct('identifier', 0);
end

end