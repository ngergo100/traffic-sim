function back_position = find_previous_in_lane(index)

global models

i = index - 1;
back_position = 0;
indexth_car_lane = models{index,2};

while (i > 0 && back_position == 0)
   ith_car_lane = models{i,2}; 
   if ith_car_lane == indexth_car_lane
       back_position = models{i,4} - models{i,6}.L;
   end
   i = i - 1;
end

end

