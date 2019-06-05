%% Case 5
clc
close all
clear

global case_name

addpath('./Configurations')

should_use_images = true;
    
load_data_for_case_5

traffic

case_name = 'case5';

post_processing_for_documentation
 
animation