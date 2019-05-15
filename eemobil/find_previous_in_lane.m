function [back_position, found_previous] = find_previous_in_lane(index)

global models

i = index - 1;
back_position = 0;
found_previous = false;
indexth_car_lane = models{index,2};

while (i > 0 && ~found_previous)
   ith_car_lane = models{i,2}; 
   if ith_car_lane == indexth_car_lane
       back_position = models{i,4} - models{i,6}.L;
       found_previous = true;
   end
   i = i - 1;
end

end

