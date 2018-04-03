%% Target Generation unit test init file

% Test 1: Change the 4 basic inputs and observe the 2 outputs. Just to make
% sure that the library actually computes things and doesnt have any basic
% errors.

% Test 2: Add in peripheral libraries to simulate a velocity point. Add in
% controller and dynamics library to make sure s/c can follow the right
% trajectory. Simulation is open loop for this test - no disturbances are
% added.

% Test 3: Simple test of flag validity. Enter zero vector input and check 
% for -1 flag and identity quaternion output.

% UW HuskySat-1, ADCS Subsystem
%  Last Update: B. Barzgaran 3.27.18
%% Load paths

clear variables; close all; clc;
set(0,'defaulttextinterpreter','latex');

% Start fresh
clear variables; close all; clc
addpath(genpath('../../../matlab/')) % adds the fsw libs
addpath(genpath('../../../../adcs_sim/matlab/')) % add the sim libs

run_test    = 3;

%% Test 1

if run_test == 1

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
t_end       = 1;
sc_mode             = 31;
sc2sun_eci_unit     = [0.5670; 0.3732; -0.7343];
vel_eci_kmps        = [0.9082; 0.3185; 0.2715];
sc2gs_eci_unit      = [-0.2821; 0.7163; 0.6382];
sc_quat             = [1; 0; 0; 0];
% -----

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'target_generation_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %

quat_cmd    = logsout.getElement('quat_cmd').Values.Data;
omega_cmd_radps    = logsout.getElement('omega_cmd_radps').Values.Data;



% ----- End Analysis ----- %

% figure(1)
% subplot(2,1,1)
% plot(tout,quat_cmd)
% title('Quaternion','FontSize',15)
% subplot(2,1,2)
% plot(tout,omega_cmd_radps)
% title('Angular Velocity [rad/s]','FontSize',15)
% xlabel('Time [s]','FontSize',12)

%save('workspace-test-NAME.mat')

elseif run_test == 2
%% Test 2

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
t_end       = 5400;
sc_mode     = 31;
sc2gs_eci_unit  = zeros(3,1);

% J  = fsw_params.bus.inertia;
% 
% % Choose damping ratio and natural frequency
% z   = 1; % Critically damped
% wn  = 0.02*2*pi; % Small natural frequency
% 
% fsw_params.control.pd_controller.p_gain  = -wn^2.*J;
% fsw_params.control.pd_controller.d_gain  = -2*wn*z.*J;
% -----

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'target_generation_test2';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
quat        = logsout.getElement('quat').Values.Data;
omega       = logsout.getElement('body_rates').Values.Data;
quat_cmd    = logsout.getElement('quat_cmd').Values.Data;
omega_cmd   = logsout.getElement('omega_cmd_radps').Values.Data;
ang_err     = logsout.getElement('angle_err').Values.Data;
cmd_torque  = logsout.getElement('cmd_torque').Values.Data;
cmd_RPM     = logsout.getElement('cmd_RPM').Values.Data;

% ----- End Analysis ----- %

figure(1)
subplot(2,1,1), hold on
plot(tout,quat)
plot(tout,quat_cmd,'--')
title('Quaternion','FontSize',15)
subplot(2,1,2), hold on
plot(tout,omega)
plot(tout,omega_cmd,'--')
title('Angular Velocity [rad/s]','FontSize',15)
xlabel('Time [s]','FontSize',12)

figure(2), hold on
plot(tout,ang_err,'LineWidth',1)
legend('x','y','z')
title('Angle Error','FontSize',15)
xlabel('Time [s]','FontSize',12)


%save('workspace-test-NAME.mat')

%% Test 3

elseif run_test == 3

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
t_end       = 1;
sc_mode             = 31;
sc2sun_eci_unit     = zeros(3,1);
vel_eci_kmps        = [0.9082; 0.3185; 0.2715];
sc2gs_eci_unit      = [-0.2821; 0.7163; 0.6382];
sc_quat             = [1; 0; 0; 0];
% -----

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'target_generation_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %

quat_cmd    = logsout.getElement('quat_cmd').Values.Data;
omega_cmd_radps    = logsout.getElement('omega_cmd_radps').Values.Data;
flag        = logsout.getElement('flag').Values.Data;

if flag(end) == -1
    disp('--- Test successful ---')
else
    disp('--- Test unsuccessful ---')
end

% ----- End Analysis ----- %

% figure(1)
% subplot(2,1,1)
% plot(tout,quat_cmd)
% title('Quaternion','FontSize',15)
% subplot(2,1,2)
% plot(tout,omega_cmd_radps)
% title('Angular Velocity [rad/s]','FontSize',15)
% xlabel('Time [s]','FontSize',12)

%save('workspace-test-NAME.mat')

end