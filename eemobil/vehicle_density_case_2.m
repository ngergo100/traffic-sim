%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
clc
close all
clear

addpath('./Configurations')

global real should_use_legend

figure_size = [10,10,14,8];
f = figure('Units','centimeters', 'Position',figure_size);
hold all;

config_count = 10;
changed_cars_count = 2;
nonzerotimes = [];

for variation_config_index=1:changed_cars_count
    
variations = nchoosek(1:config_count, variation_config_index);

for index=1:size(variations,1)
    should_use_images = false;
    
    load_data_set_1
    
    actual_variation = variations(index,:);
    
    for i=1:length(actual_variation)
        driver = IDModel(struct('a_max',1.2, 'b_max',3, 'v_0',50/3.6, 'T',1.8, 'h_0',1, 'delta',4, 'L',4.2, 'time_to_change_lane',1, 'lane_change_duration',2.0, 'not_paying_attention',[], 'acceleration_threshold',10, 'acceleration_difference_threshold',0.3, 'p',0));

        dataset_helper(driver, actual_variation(i))
    end

    traffic

    %post_processing
 
    %animation
    real = false;
    should_use_legend = false;
    
    vehicle_density_post_processing
    
    nonzerotimes = [nonzerotimes,t(length(t))];
    
    clearvars -except nonzerotimes variations config_count
end

end

set(gca,'fontsize',8')
xlabel('t[s]')
ylabel('n[-]')
axis([0 inf 0 inf])
print('Resources/vehicle_density_case_2','-depsc');

% Save latex table content
fid = fopen('Resources/vehicle_density_table_case_template','rt') ;
X = fread(fid);
fclose(fid);
X = char(X.');
X = strrep(X, 'minvar', num2str(round(min(nonzerotimes)*100)/100));
X = strrep(X, 'maxvar', num2str(round(max(nonzerotimes)*100)/100));
X = strrep(X, 'avgvar', num2str(round(mean(nonzerotimes)*100)/100));
X = strrep(X, 'stdvar', num2str(round(std(nonzerotimes)*100)/100));
fid2 = fopen('Resources/vehicle_density_table_case_2','wt') ;
fwrite(fid2,X);
fclose(fid2);
