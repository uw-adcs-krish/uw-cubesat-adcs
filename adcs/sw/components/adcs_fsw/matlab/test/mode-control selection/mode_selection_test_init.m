%% mode selection unit test init file

% Test 1: 

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

%% Test 1 no inputs

% t_end   = 86400; % Sim for 1 day
t_end   = 6400;
t = [0:t_end]';

CANvals = [0,0,0,0,0,0,0]';
CAN.time = t;
CAN.signals.values = repmat(CANvals,[1 1 length(t)]);
CAN.signals.dimensions = [7,1];

sc_in_sun = [t,zeros(t_end+1,1)];
GS_approach = [t,zeros(t_end+1,1)];
omega_body_radps = [t,zeros(t_end+1,1)];;
RW_RPM = [t,zeros(t_end+1,1)];
sc_mode_last = 1;

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'mode_selection_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim
sc_mode = logsout.getElement('sc_mode').Values.Data;
sc_experimental = logsout.getElement('sc_experimental').Values.Data;

%% Test 2 activate desat and turn back off

% t_end   = 86400; % Sim for 1 day
t_end   = 6400;
t = [0:t_end]';

CANvals = [0,0,1,0,0,0,0]';
CAN.time = t;
CAN.signals.values = repmat(CANvals,[1 1 length(t)]);
CAN.signals.dimensions = [7,1];

sc_in_sun = [t,0*ones(t_end+1,1)];
GS_approach = [t,0*ones(t_end+1,1)];
omega_body_radps = [t,zeros(t_end+1,1)];

RW_RPM = [t,[linspace(3000,15000,t_end/2) linspace(15000,1000,t_end/2+1)]'];

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'mode_selection_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim
sc_mode = logsout.getElement('sc_mode').Values.Data;
sc_experimental = logsout.getElement('sc_experimental').Values.Data;


%% Test 3 experimental control

% t_end   = 86400; % Sim for 1 day
t_end   = 6400;
t = [0:t_end]';

CANvals = [0,0,1,1,0,1,2]';
CAN.time = t;
CAN.signals.values = repmat(CANvals,[1 1 length(t)]);
CAN.signals.dimensions = [7,1];

sc_in_sun = [t,1*ones(t_end+1,1)];
GS_approach = [t,1*ones(t_end+1,1)];
omega_body_radps = [t,zeros(t_end+1,1)];
RW_RPM = [t,8000*ones(t_end+1,1)];

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'mode_selection_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim
sc_mode = logsout.getElement('sc_mode').Values.Data;
sc_experimental = logsout.getElement('sc_experimental').Values.Data;
