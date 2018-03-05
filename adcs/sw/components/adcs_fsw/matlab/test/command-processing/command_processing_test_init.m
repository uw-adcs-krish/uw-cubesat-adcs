%% Command Processing unit test init file
% UW HuskySat-1, ADCS Team
%
% Test 1: Basic test with different input signals. The plots show the
% responses in various axes.
%
% Primary Test: T. Reynolds 2.23.18
%% Assuming sim_init.m has been run
close all; clc
set(0,'defaulttextinterpreter','latex');

% Constants

% Choose test
run_test    = 1;

%% Test 1

if run_test == 1
    
t_end   = 100;

% Run Sim
run_time    = num2str(t_end);
mdl         = 'command_processing_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_RPM     = logsout.getElement('cmd_RPM').Values.Data;
cmd_DV      = logsout.getElement('cmd_DV').Values.Data;
torque_in   = logsout.getElement('torque_Nm_RW').Values.Data;
dipole_in   = logsout.getElement('dipole_Am2_MT').Values.Data;
tout        = tout(2:end);

figure(1)
subplot(2,1,1)
plot(tout,cmd_DV(:,3),'LineWidth',1)
ylabel('DV'); title('Commanded dipole vs. Digital Value','FontSize',15)
subplot(2,1,2)
plot(tout,dipole_in(:,3),'LineWidth',1)
xlabel('Time [s]'); ylabel('Dipole')


figure(2)
subplot(2,1,1)
plot(tout,cmd_RPM(:,1),'LineWidth',1)
ylabel('RPM'); title('Commanded RPM vs. Torque','FontSize',15) 
subplot(2,1,2)
plot(tout,torque_in(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('Torque [Nm]')


%save('workspace-test-NAME.mat')

elseif run_test == 2
% no test 2 for now

%save('workspace-test-NAME.mat')

end