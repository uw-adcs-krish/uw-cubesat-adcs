%% gyroscope sensor processing unit test init file

% Test 1: Runs the gyro sensor and sensor processing unit for 1 day to
% capture a roll over in the gyro sensor and make sure things look okay. Use
% accompanying simulink model to check that the TLE matches.

% UW HuskySat-1, ADCS Subsystem
%  Last Update: S.Rice 3/26/18
%% Load paths

% Start fresh
clear variables; close all; clc
set(0,'defaulttextinterpreter','latex');
addpath(genpath('../../../../matlab/')) % adds the fsw libs
addpath(genpath('../../../../../adcs_sim/matlab/')) % add the sim libs

% Load bus stub definitions
load('bus_definitions.mat')

run_test    = 1;
%% Test 1

if run_test == 1

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
t_end   = 100;
% -----

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'gyro_processing_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %

gyro_br_fsw    = logsout.getElement('gyro_br_fsw').Values.Data;
gyro_br_sensor    = logsout.getElement('gyro_br_sensor').Values.Data;
gyro_br_in    = logsout.getElement('gyro_br_in').Values.Data;
gyro_sensor_time    = logsout.getElement('gyro_br_sensor').Values.Time;
% orbit_tle   = logsout.getElement('orbit_tle').Values.Data;
tout = gyro_sensor_time;

% ----- End Analysis ----- %

figure(1)
subplot(3,1,1)
plot(tout(1:end),gyro_br_in(1:end,1),'LineWidth',1); hold on
plot(tout(1:end),gyro_br_in(1:end,2),'LineWidth',1);
plot(tout(1:end),gyro_br_in(1:end,3),'LineWidth',1);
title('Actual body rates','FontSize',15)
subplot(3,1,2)
plot(tout(1:end),gyro_br_sensor(1:end,1),'LineWidth',1); hold on
plot(tout(1:end),gyro_br_sensor(1:end,2),'LineWidth',1);
plot(tout(1:end),gyro_br_sensor(1:end,3),'LineWidth',1);
title('gyro sim output','FontSize',15)
subplot(3,1,3)
plot(tout(1:end),gyro_br_fsw(1:end,1),'LineWidth',1); hold on
plot(tout(1:end),gyro_br_fsw(1:end,2),'LineWidth',1);
plot(tout(1:end),gyro_br_fsw(1:end,3),'LineWidth',1);
title('processed gyro output','FontSize',15)
xlabel('Time [s]','FontSize',12)

%save('workspace-test1-gyro.mat')

elseif run_test == 2
%% Test 2
clear variables; close all; clc

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
t_end   = 100;
% -----

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'gyro_processing_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze + Plot Results ----- %


% ----- End Analysis ----- %

%save('workspace-test2-NAME.mat')



end

