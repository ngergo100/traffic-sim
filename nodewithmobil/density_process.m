function [count_over_time] = density_process(y, target_line)

positions = y(1:2:end,:);
count_over_time = zeros(1,size(positions,2));

for i=1:size(positions,2)
    positions_ith = positions(:,i);
    count_over_time(i) = sum(positions_ith > target_line);
end

end

