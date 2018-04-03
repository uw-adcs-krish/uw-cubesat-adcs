%% Command Processing unit test init file
% UW HuskySat-1, ADCS Team
%
% Test 1: Basic test with different input signals. The plots show the
% responses in various axes.
%
% Primary Test: A. Fogwell 3/27/18
%% Assuming sim_init.m has been run
close all; clc
set(0,'defaulttextinterpreter','latex');

% Constants

% Choose test
run_test    = 8;

%% Test 1

if run_test == 1
t_end   = 1;
sc_mode = 0; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 2
elseif run_test == 2    
t_end   = 1;
sc_mode = 1; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 3
elseif run_test == 3    
t_end   = 1;
sc_mode = 2; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 4
elseif run_test == 4    
t_end   = 1;
sc_mode = 3; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 5
elseif run_test == 5    
t_end   = 1;
sc_mode = 4; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 6
elseif run_test == 6    
t_end   = 1;
sc_mode = 31; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 7
elseif run_test == 7    
t_end   = 1;
sc_mode = 32; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

%% Test 8
elseif run_test == 8    
t_end   = 1;
sc_mode = 33; 
% Run Sim
run_time    = num2str(t_end);
mdl         = 'MSP_mt_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analyze Results
cmd_MT_fsw_dv = zeros(size(tout))
cmd_MT_bdot = ones(size(tout)) 

figure(1)
subplot(3,1,1)
plot(tout,cmd_MT_out(:,3),'LineWidth',1)
ylabel('cmd_out')
title('Commanded Out vs. FSW or BDot','FontSize',15)
subplot(3,1,2)
plot(tout,cmd_MT_fsw_dv(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('FSW')
subplot(3,1,3)
plot(tout,cmd_MT_bdot(:,1),'LineWidth',1)
xlabel('Time [s]'); ylabel('BDot')

end