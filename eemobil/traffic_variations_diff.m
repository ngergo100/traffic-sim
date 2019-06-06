%% Define the model
% parameters in models
% id, sourcelane, targetlane, initial position, initial velocity, ACC model
clc
close all
clear

addpath('./Configurations')

config_count = 10;
changed_cars_count = 10;

load('times_case1.mat')

for variation_config_index=1:changed_cars_count
    
groupsmall = zeros(1,variation_config_index);
groupbig = zeros(1,variation_config_index);
    
variations = nchoosek(1:config_count, variation_config_index);

for index=1:size(variations,1)
    
    actual_variation = variations(index,:);
    
    if times(index,variation_config_index) < 27.5
        if ismember(actual_variation,groupsmall,'rows')==0
            groupsmall = [groupsmall;actual_variation];
        end
    else        
        if ismember(actual_variation,groupbig,'rows')==0
            groupbig = [groupbig;actual_variation];
        end
    end
    
%     fprintf(['Progress of variation: ' num2str(index) '/' num2str(size(variations,1)) '\nProgress of varitaions: ' num2str(variation_config_index) '/' num2str(changed_cars_count) '\n'])
    
    clearvars -except config_count changed_cars_count variations times variation_config_index groupsmall groupbig
end

disp('Variation diff')
setdiff(groupsmall,groupbig,'rows')

clearvars -except config_count changed_cars_count variations times variation_config_index

end
