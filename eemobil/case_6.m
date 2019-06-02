%% Case 6
clc
close all
clear

global case_name

addpath('./Configurations')

should_use_images = false;
    
load_data_for_case_6

traffic

case_name = 'case6';

post_processing_for_documentation
 
animation