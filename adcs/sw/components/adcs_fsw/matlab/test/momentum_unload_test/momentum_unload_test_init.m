%% Momentum unload unit test init file
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
% fsw_params.actuators.ic.RW_RPM = 2000*ones(3,1);
% fsw_params.actuators.ic.RW_omega_radps  = fsw_params.convert.RPM_2_RADPS.*2000*ones(3,1);

%sim_params.environment.avg_b = [1.59212e-5 -6.1454e-6 4.0276e-5]; % T
%sim_params.dynamics.ic.rate_init = [0.1; 0.1; 0.1];
% -----
% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'momentum_dump_test_rev2';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
%sldebug(mdl);

% % ----- Analyze Results ----- %
% 
% quat    = logsout.getElement('<quaternion>').Values.Data;
% omega   = logsout.getElement('<body_rates>').Values.Data;
% cmdu       = logsout.getElement('cmd_torque').Values.Data;
% realu       = logsout.getElement('torque').Values.Data;
% mag_dip     = logsout.getElement('magnetic_dipole').Values.Data;
% real_time   = logsout.getElement('torque').Values.Time;
% cmdRPM     = squeeze(logsout.getElement('cmd_rpm').Values.Data);
% realRPM     = logsout.getElement('real_RPM').Values.Data;
% 
% q_d     = fsw_params.bus.quat_commanded;
% diff    = zeros(1,length(tout));
% for i = 1:length(tout)
%     q_diff  = quatmultiply(quatconj(q_d'),quat(i,:));
%     diff(i) = norm( q_diff(2:4) ) ;
% end
% 
% 
% % ----- End Analysis ----- %
% 
% figure(1)
% subplot(2,1,1)
% plot(tout,quat)
% title('Quaternion','FontSize',15)
% subplot(2,1,2)
% plot(tout,omega)
% title('Angular Velocity [rad/s]','FontSize',15)
% xlabel('Time [s]','FontSize',12)
% 
% figure(2)
% subplot(2,2,1)
% plot(real_time,cmdu)
% title('Commanded Torque [Nm]','FontSize',15)
% subplot(2,2,2)
% plot(tout,cmdRPM)
% title('Commanded RW RPM','FontSize',15)
% xlabel('Time [s]','FontSize',12)
% subplot(2,2,3)
% plot(real_time,realu)
% title('Actual Torque [Nm]','FontSize',15)
% subplot(2,2,4)
% plot(tout,realRPM)
% title('Actual RW RPM','FontSize',15)
% xlabel('Time [s]','FontSize',12)
% 
% figure(3), hold on
% plot(tout,diff,'LineWidth',1)
% plot(tout,0.02*ones(1,length(tout)),'k--')
% %plot([ts ts],[0 1],'k--')
% xlabel('Time [s]','FontSize',12)
% 
% %save('workspace-test-NAME.mat')
end

