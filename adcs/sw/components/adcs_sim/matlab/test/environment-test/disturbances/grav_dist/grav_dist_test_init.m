%% Gravity gradient unit test init file

% Test 1: Plug in a lat/lon/alt and observe the magnitude of the gravity
% field. Static test. Compared with online calculator at 
% https://planetcalc.com/1758/.

% UW HuskySat-1, ADCS Subsystem
%  Last Update: T. Reynolds 12.5.17
%% Load paths and stuff needed
clear variables;

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);
fsw_params.bdot     = init_bdot_controller(fsw_params);

%% Test 1

% Overrides
lat     = 45;
lon     = -122;
alt     = 500e3;
% -----
t_end   = 1;

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'grav_dist_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim
grav_eci_ms2 = logsout.getElement('grav_eci_ms2').Values.Data;
DT_gg = logsout.getElement('DT_gg').Values.Data;

g   = norm(grav_eci_ms2(end,:));
disp(['Acceleration due to gravity is: ',num2str(g),'m/s2 at ',...
        num2str(alt/1e3),'km altitude and ',num2str(lat),' deg latitude']);
% ----- Plot Results ----- %

%save('workspace-disturbances-test1.mat')

