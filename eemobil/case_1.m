%% Case 1
clc
close all
clear

global case_name

addpath('./Configurations')

should_use_images = false;
    
load_data_set_5

traffic

case_name = 'case1';

post_processing_for_documentation
 
%animation