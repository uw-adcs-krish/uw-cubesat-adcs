% run sim init before starting this script
clc; close all;
set(0,'defaulttextinterpreter','latex');
%cd /media/sexymathemagician/LaCie1/uw_cubesat_adcs/adcs/sw/components/adcs_fsw/matlab/test/triad-test/
addpath(genpath(pwd))

rng(155);

figdir = strcat(pwd,'/figs/');
datadir = strcat(pwd,'/data/');

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% attitude conditions
quat_cmd = -[-0.1 0.2 0.3 0.4]';
quat_cmd = quat_cmd/norm(quat_cmd);
sim_params.dynamics.ic.quat_init = [1 0 0 0];
q = rand(4,1);
fsw_params.estimation.ic.quat_est_init = q./norm(q);

fsw_params.estimation.ic.rt_w_body_radps = 0*[0.1 -0.05 -0.03]';
sim_params.dynamics.ic.rate_init = 0*[0.1 -0.05 -0.03]';

% make the noise larger (set 1 otherwise)
var_mult_mt = 10000;
var_mult_sun = 10000;

% measurement vectors
mag_vec_init = [4 1 -8]';
mag_vec_init = mag_vec_init/norm(mag_vec_init);

sun_vec_init = [9 -3 18]';
sun_vec_init = sun_vec_init/norm(sun_vec_init);

% body frame
A = quatToMatrix(quat_cmd);
fsw_params.estimation.ic.rt_mag_eci_est = A'*mag_vec_init;
fsw_params.estimation.ic.rt_sun_eci_est = A'*sun_vec_init;

% reference frame
fsw_params.estimation.ic.rt_mag_body = mag_vec_init;
fsw_params.estimation.ic.rt_sun_body = sun_vec_init;

run_time    = '200';
mdl         = 'controller_TRIAD_minimal';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% h1 = figure;
% plot(omega_hat.Time, omega_hat.Data(:,1),'r--'), hold on
% plot(omega_hat.Time, omega_hat.Data(:,2),'b--')
% plot(omega_hat.Time, omega_hat.Data(:,3),'k--')
% plot(omega_true.Time, omega_true.Data(:,1),'r')
% plot(omega_true.Time, omega_true.Data(:,2),'b')
% plot(omega_true.Time, omega_true.Data(:,3),'k')

h2 = figure;
plot(quat_hat.Time, quat_hat.Data(:,1),'r--'), hold on
plot(quat_hat.Time, quat_hat.Data(:,2),'b--')
plot(quat_hat.Time, quat_hat.Data(:,3),'k--')
plot(quat_hat.Time, quat_hat.Data(:,4),'g--')
plot(quat_true.Time, quat_true.Data(:,1),'r')
plot(quat_true.Time, quat_true.Data(:,2),'b')
plot(quat_true.Time, quat_true.Data(:,3),'k')
plot(quat_true.Time, quat_true.Data(:,4),'g')
plot(quat_true.Time, quat_cmd(1)*ones(size(quat_true.Time)), 'k','linewidth',2)
plot(quat_true.Time, quat_cmd(2)*ones(size(quat_true.Time)), 'k','linewidth',2)
plot(quat_true.Time, quat_cmd(3)*ones(size(quat_true.Time)), 'k','linewidth',2)
plot(quat_true.Time, quat_cmd(4)*ones(size(quat_true.Time)), 'k','linewidth',2)
