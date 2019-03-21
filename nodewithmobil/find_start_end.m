function [start_number, end_number] = find_start_end(i, array)
i_number = array(i);

next_number = i;
while next_number ~= 0
    next_number = next_number - 1;
    if array(next_number) ~= i_number
        start_number = next_number+1;
        next_number = 0;
    end
end

next_number = i;
while next_number ~= 0
    next_number = next_number + 1;
    if array(next_number) ~= i_number
        end_number = next_number-1;
        next_number = 0;
    end
end

end

