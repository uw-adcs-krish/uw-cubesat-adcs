%% Aerodynamic drag unit test init file

% Test 1: Plug in a lat/lon/alt and observe the magnitude of the gravity
% field. Static test.

% UW HuskySat-1, ADCS Subsystem
%  Last Update: B. Barzgaran 2.20.18
%% Load paths and stuff needed
clear variables;

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

%% Test 1

% Overrides

% -----

% Simulation parameters
run_time    = num2str(100);
mdl         = 'aero_drag_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim
dt_aero = logsout.getElement('DT_aero').Values.Data;
dt_aero_time = logsout.getElement('DT_aero').Values.Time;


% ----- Plot Results ----- %

%save('workspace-disturbances-test1.mat')

