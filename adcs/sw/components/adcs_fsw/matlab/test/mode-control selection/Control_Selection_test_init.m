%% Control Selection unit test init file
% Simple tests for Control Selection Library, library functionality is
% simple and performs as intended
% UW HuskySat-1, ADCS Subsystem
%  Last Update: Sean Rice 1/20/18
%% Load paths and stuff needed
clear variables;

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);
fsw_params.bdot     = init_bdot_controller(fsw_params);

%% Test 1

% t_end   = 86400; % Sim for 1 day
t_end   = 6400;
t = [0:t_end]';

sc_mode = [t,31*ones(t_end+1,1)];
cmd_magvals = [11000,11000,11000]';

cmd_mag.time = t;
cmd_mag.signals.values = repmat(cmd_magvals,[1 1 length(t)]);
cmd_mag.signals.dimensions = [3,1];

cmd_rwvals = [11000,11000,11000]';

cmd_rw.time = t;
cmd_rw.signals.values = repmat(cmd_rwvals,[1 1 length(t)]);
cmd_rw.signals.dimensions = [3,1];

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'Control_Selection_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim

cmd_RW_out = logsout.getElement('cmd_RW_out').Values.Data;
cmd_MAG_out = logsout.getElement('cmd_MAG_out').Values.Data;
ctrl_status = logsout.getElement('ctrl_status').Values.Data;
