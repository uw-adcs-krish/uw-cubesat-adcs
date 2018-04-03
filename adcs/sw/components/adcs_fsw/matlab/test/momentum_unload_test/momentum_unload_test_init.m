%% Momentum unload unit test init file
% Two main tests are run: 1. command quaternion same as intial quaternion,
% initial RPM nonzero (~2000 is usually used) - should result in the
% magentorquers slowly unloading the momentum (should certainly take more
% than one orit), 2. command quaternion different from initial quaternion,
% initial RPM 0 - should result in the RPM dropping after the reorientation
% is achieved. 

% NOTE: disturbances were zeroed for these tests, when revisiting after
% delivery should run tests with disturbances not zeroed
% UW HuskySat-1, ADCS Subsystem
%  Last Update: E.Hansen 12.27.17
%% Load paths

clear variables; close all; clc;
set(0,'defaulttextinterpreter','latex');

% Start fresh
clear variables; close all; clc
addpath(genpath('../../../matlab/')) % adds the fsw libs
addpath(genpath('../../../../adcs_sim/matlab/')) % add the sim libs

run_test    = 1;

t_end   = 5400;
%% Test 1
if run_test == 1
% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
%sim_params.environment.avg_b = [1.59212e-5 -6.1454e-6 4.0276e-5]; % T

% -----
% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'momentum_dump_test_rev2';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
%sldebug(mdl);

% % ----- Analyze Results ----- %

end

