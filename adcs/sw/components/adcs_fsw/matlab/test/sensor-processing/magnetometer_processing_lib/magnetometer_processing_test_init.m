%% Magnetometer sensor processing unit test init file

% Test 1: 

% UW HuskySat-1, ADCS Subsystem
%  Last Update: S. Rice 3/4/18
%% Load paths

% Start fresh
% clear variables; close all; clc
set(0,'defaulttextinterpreter','latex');
addpath(genpath('../../../../matlab/')) % adds the fsw libs
addpath(genpath('../../../../../adcs_sim/matlab/')) % add the sim libs

% Load bus stub definitions
load('bus_definitions.mat')

%% Test 1

% Load parameters for both flight software and simulation
% fsw_params = init_fsw_params();
% [sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
t_end   = 100;
% -----

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'magnetometer_processing_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %

mag_body_processed_T    = logsout.getElement('mag_body_processed_T').Values.Data;

% ----- End Analysis ----- %
