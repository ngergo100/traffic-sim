[vehicle_density, jumps, values] = density_process(y,target_line);
    
figure(5)
hold all;
%% Real lane change plot
%plot(t,vehicle_density, 'DisplayName',num2str(index)) 

%% Averaged plot
plot(jumps*dt,values, 'DisplayName',num2str(index))
legend('-DynamicLegend');