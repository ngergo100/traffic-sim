[vehicle_density, jumps, values] = density_process(y,target_line);
plot(t,vehicle_density, 'DisplayName',DisplayName) 
legend('-DynamicLegend', 'Location', 'northwest');