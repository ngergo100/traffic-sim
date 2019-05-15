function [count_over_time, jumps, values] = density_process(y, target_line)

positions = y(1:2:end,:);
count_over_time = zeros(1,size(positions,2));

for i=1:size(positions,2)
    positions_ith = positions(:,i);
    count_over_time(i) = sum(positions_ith > target_line);
end
count_changes = diff(count_over_time);
jumps = find(count_changes>0.5);
change_value = count_changes(jumps);
values = [change_value(1)];
for i=2:length(change_value)
    values(i) = values(i-1) + change_value(i-1);
end
end

