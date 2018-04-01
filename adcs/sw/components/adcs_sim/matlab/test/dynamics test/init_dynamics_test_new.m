%% Dynamics unit test init file
% Tests the dynamics block. All disturbance torques in the environment
% block are zero'd.

% UW HuskySat-1, ADCS Subsystem
%  Last Update: E. Hansen 3.31.18
%% Run sim_init first!!!

clear variables; close all; clc;
set(0,'defaulttextinterpreter','latex');

%% Tests
test = 7;
%Test numbers and associated valid results:
%**The norm of the position should always be around 7*10^(3)km**
% 1 - all 0 inputs -> should result in no changes to body rates or
% quaternion
% 2 - 0 torque, step dipole from max dipole moment in first coordinate to 0
% -> should result in 'fast' changes to the body rates when the dipole is 
% active, and then should maintain the body rate of when the
% dipole was turned off
% 3 - 0 dipole, step torque to max torque in first coordinate -> should 
% result in 'fast' changes to the body rates when the dipole is active, 
% and then should maintain the body rate of when the RW are not moving
% 4 - pulse torque, 0 dipole -> should result in no changes from test1
% until pulse, then the result should be similar to test 3
% 5 - 0 torque, pulse dipole -> should result in no changes from test1
% until pulse, then the result should be similr to test 2
% 6 - constant nonzero torque, 0 dipole -> should result in steady
% increase in body rates as time goes on (bc of how RW torque acts in the
% body rates DE
% 7 - 0 torque, constant nonzero dipole -> should result in 

% Load bus stub definitions
load('bus_definitions.mat')

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);
t_end = 1000;

if test==1
    RW_torque_const = [0;0;0];
    RW_input = 1; %RW constant
    MT_dipole_const = [0;0;0];
    MT_input = 1; %MT constant
elseif test==2
    RW_torque_const = [0;0;0];
    RW_input = 1; %RW constant
    MT_dipole_const = [0;0;0];
    MT_input = 2; %MT step
elseif test == 3
    RW_torque_const = [0;0;0];
    RW_input = 2; %RW step
    MT_dipole_const = [0;0;0];
    MT_input = 1; %MT constant
elseif test==4
    RW_torque_const = [0;0;0];
    RW_input = 3; %RW pulse
    MT_dipole_const = [0;0;0];
    MT_input = 1; %MT constant
elseif test==5
    RW_torque_const = [0;0;0];
    RW_input = 1; %RW constant
    MT_dipole_const = [0;0;0];
    MT_input = 3; %MT pulse
elseif test==6
    RW_torque_const = fsw_params.control.pd_controller.max_torque*ones(3,1);
    RW_input = 1; %RW constant
    MT_dipole_const = [0;0;0];
    MT_input = 1; %MT pulse
elseif test==7
    RW_torque_const = [0;0;0];
    RW_input = 1; %RW constant
    MT_dipole_const = 0.15*ones(3,1);
    MT_input = 1; %MT pulse
end

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'dynamics_test2_sim';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
%   extract pos/vel/time data from sim
orbit_data = logsout.getElement('orbit_data').Values;
states  = logsout.getElement('states').Values;
norm(states.position_eci_km.Data(1,:))
norm(states.position_eci_km.Data(end,:))
% ----- End Analysis ----- %
