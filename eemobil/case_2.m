%% Case 2
clc
close all
clear

global case_name

addpath('./Configurations')

should_use_images = false;
    
load_data_for_case_2

traffic

case_name = 'case2';

post_processing_for_documentation
 
%animation