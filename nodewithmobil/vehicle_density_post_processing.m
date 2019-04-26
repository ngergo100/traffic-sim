vehicle_density = density_process(y,target_line);
    
figure(5)
hold all;
plot(t,vehicle_density, 'DisplayName',num2str(index)) 
legend('-DynamicLegend');