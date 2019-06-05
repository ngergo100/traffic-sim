%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
clc
close all
clear

addpath('./Configurations')
cars_count = 10;
change = 0.75;
name = 'case2';

% Save latex table content
fid = fopen('Resources/vehicle_density_par_template','rt') ;
X = fread(fid);
fclose(fid);
table = char(X.');

figure_size = [10,10,14,8];
f = figure('Units','centimeters', 'Position',figure_size);
hold all;

%% Original
load_data_for_case_5
traffic
table = strrep(table, 'torig', num2str(t(length(t))));
DisplayName = 'Original';
post_process_density_parameter
clearvars -except cars_count f figure_size change table name

%% a_max
load_data_for_case_5
for i=1:cars_count
    models{i,6}.a_max = models{i,6}.a_max*change;
end
traffic
table = strrep(table, 'tamax', num2str(t(length(t))));
DisplayName = 'a_{max}';
post_process_density_parameter
clearvars -except cars_count f figure_size change table name

%% T
load_data_for_case_5
for i=1:cars_count
    models{i,6}.T = models{i,6}.T*change;
end
traffic
table = strrep(table, 'tt', num2str(t(length(t))));
DisplayName = 'T';
post_process_density_parameter
clearvars -except cars_count f figure_size change table name

%% h_0
load_data_for_case_5
for i=1:cars_count
    models{i,6}.h_0 = models{i,6}.h_0*change;
end
traffic
table = strrep(table, 'th0', num2str(t(length(t))));
DisplayName = 'h_0';
post_process_density_parameter
clearvars -except cars_count f figure_size change table name

%% lane_change_duration
load_data_for_case_5
for i=1:cars_count
    models{i,6}.lane_change_duration = models{i,6}.lane_change_duration*change;
end
traffic
table = strrep(table, 'tlanechange', num2str(t(length(t))));
DisplayName = 'lcduration';
post_process_density_parameter
clearvars -except cars_count f figure_size change table name

%% acceleration_difference_threshold
load_data_for_case_5
for i=1:cars_count
    models{i,6}.acceleration_difference_threshold = models{i,6}.acceleration_difference_threshold*change;
end
traffic
table = strrep(table, 'thresh', num2str(t(length(t))));
DisplayName = 'adiffthresh';
post_process_density_parameter
clearvars -except cars_count f figure_size change table name

set(gca,'fontsize',8')
xlabel('t[s]')
ylabel('n[-]')
axis([0 inf 0 inf])
print(['Resources/vehicle_density_par_pos_' name],'-depsc');

fid2 = fopen(['Resources/vehicle_density_par_pos_tab_' name],'wt') ;
fwrite(fid2,table);
fclose(fid2);
disp('Done')