function paying_attention = is_paying_attention_at_the_moment(time_intervals, t)

paying_attention = true;

for i=1:size(time_intervals,1)
    ith_time_interval = time_intervals(i,:);
    if ith_time_interval(1)<=t && ith_time_interval(2)>t
        paying_attention = false;
        break
    end
end

end