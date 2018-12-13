function headways = prepare_headways(positions, lane_config, identifiers)
    headways = zeros(size(positions));
    
    for i=1:size(positions,2)
        traffic = [positions(:,i), lane_config(:,i), identifiers];
        sorted_traffic = sortrows(traffic);
        for j=1:size(positions,1)
            traffic_in_my_lane = sorted_traffic(sorted_traffic(:,2) == lane_config(j,i),:);
            my_index = find(traffic_in_my_lane(:,3) == identifiers(j));
            if size(traffic_in_my_lane, 1) > my_index
                leading_car_data = traffic_in_my_lane(my_index + 1,:);
                headways(j,i)=leading_car_data(1)-positions(j,i);
            else
                headways(j,i)=-1;
            end
        end
    end
end

