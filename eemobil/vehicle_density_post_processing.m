[vehicle_density, jumps, values] = density_process(y,target_line);

if real 
    %% Real lane change plot
    plot(t,vehicle_density, 'DisplayName',num2str(index)) 
else
    %% Averaged plot
    plot(jumps*dt,values, 'DisplayName',num2str(index))
end

legend('-DynamicLegend', 'Location', 'southwest');