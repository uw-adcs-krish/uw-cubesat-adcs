%% EKF Estimator Test
% Test 1:
%   Provide static inertial vectors and random initial estimator states.
%   The controller should steer the estimated state the (static) commanded
%   state. Required estimator convergencence in under 60s.

% UW HuskySat-1, ADCS Subsystem
%   Primary: M. Hudoba de Badyn -- 2.25.18
%   Secondary: T. Reynolds -- 3.6.18

% Note: Assumes sim_init.m has been run
clc; close all;
set(0,'defaulttextinterpreter','latex');
%% Test 1

% figure name prefix
filename = 'full_test_nonrand_';

% seed the random initial conditions so you get the same stuff everytime

%rng(155) gives particularly bad performance due to insanely suboptimal
%initial conditions
rng(155);

% turn the controller on/off <=> 1/0; the gain block appears in "Dynamics
% Subsystem"
ctrlGain = 1;

% Attitude conditions
quat_cmd = [1 0 0 0]'; %randn(4,1);
quat_cmd = quat_cmd/norm(quat_cmd);
sim_params.dynamics.ic.quat_init        = [1 0 0 0]';
fsw_params.estimation.ic.quat_est_init  = [ 0.1399;
                                            0.6237;
                                           -0.3252;
                                           -0.6969]; %rand(4,1);

% Angular velocity
fsw_params.estimation.ic.rt_w_body_radps    = 0*[0.01 -0.05 -0.03]';
sim_params.dynamics.ic.rate_init            = 0*[0.1 -0.05 -0.03]';

% make the noise larger (set 1 for flight values)
var_mult_mt     = 1;
var_mult_sun    = 1;
var_mult_gyro   = 1;

% Inertial measurement vectors
mag_vec_init = [4 1 -8]';
mag_vec_init = mag_vec_init/norm(mag_vec_init);

sun_vec_init = [9 -3 18]';
sun_vec_init = sun_vec_init/norm(sun_vec_init);

% body frame
A = quatToMatrix(quat_cmd);
fsw_params.estimation.ic.rt_mag_eci_est = mag_vec_init;%.*randn(3,1);
fsw_params.estimation.ic.rt_sun_eci_est = sun_vec_init;%.*randn(3,1);

% reference frame
fsw_params.estimation.ic.rt_mag_body = A'*mag_vec_init;%.*randn(3,1);
fsw_params.estimation.ic.rt_sun_body = A'*sun_vec_init;%.*randn(3,1);

% stop condition (degree error from estimate to true quat)
sim_tol = 1E-100; %make this ridiculously small if you want the sim to run
                  %the full length. A reasonable value is like 0.1 rad

% Run the test
run_time    = '200';
mdl         = 'controller_estimator_test_static';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

%% Plot results
set(0,'defaultAxesFontSize',14)
% body rates

% compute axes to plot on
ax_bnd = std(abs(omega_true.Data(:,:)));
t = omega_hat.Time;

h1 = figure;
subplot(3,1,1)
plot(omega_hat.Time, omega_hat.Data(:,1),'r--'), hold on
plot(omega_true.Time, omega_true.Data(:,1),'r')
axis([t(1) t(end) -3*ax_bnd(1) 3*ax_bnd(1)])
ylabel('$\omega_x$'), xlabel('t')
title('$\omega(t)$ (solid) and $\hat \omega(t)$ (dashed)')

subplot(3,1,2)
plot(omega_hat.Time, omega_hat.Data(:,2),'b--'), hold on
plot(omega_true.Time, omega_true.Data(:,2),'b')
axis([t(1) t(end) -3*ax_bnd(2) 3*ax_bnd(2)])
ylabel('$\omega_y$'), xlabel('t')

subplot(3,1,3)
plot(omega_true.Time, omega_true.Data(:,3),'k'), hold on
plot(omega_hat.Time, omega_hat.Data(:,3),'k--')
axis([t(1) t(end) -3*ax_bnd(3) 3*ax_bnd(3)])
ylabel('$\omega_z$'), xlabel('t')

% quaternion
h2 = figure;
subplot(4,1,1)
plot(quat_hat.Time, quat_hat.Data(:,1),'r--'), hold on
plot(quat_true.Time, quat_true.Data(:,1),'r')
plot(quat_true.Time, quat_cmd(1)*ones(size(quat_true.Time)), 'k','linewidth',2)
ylabel('$q_1(t)$'), xlabel('t')
title('$q(t)$ (solid) and $\hat q(t)$ (dashed); $q_{cmd}$ (black)')

subplot(4,1,2)
plot(quat_hat.Time, quat_hat.Data(:,2),'b--'), hold on
plot(quat_true.Time, quat_true.Data(:,2),'b')
plot(quat_true.Time, quat_cmd(2)*ones(size(quat_true.Time)), 'k','linewidth',2)
ylabel('$q_2(t)$'), xlabel('t')

subplot(4,1,3)
plot(quat_hat.Time, quat_hat.Data(:,3),'k--'), hold on
plot(quat_true.Time, quat_true.Data(:,3),'k')
plot(quat_true.Time, quat_cmd(3)*ones(size(quat_true.Time)), 'k','linewidth',2)
ylabel('$q_3(t)$'), xlabel('t')

subplot(4,1,4)
plot(quat_hat.Time, quat_hat.Data(:,4),'g--'), hold on
plot(quat_true.Time, quat_true.Data(:,4),'g')
plot(quat_true.Time, quat_cmd(4)*ones(size(quat_true.Time)), 'k','linewidth',2)
ylabel('$q_4(t)$'), xlabel('t')

% bias
h3 = figure;
plot(bias_hat)
title('Gyroscope bias estimate')

% quat error
h4 = figure;
[len,~] = size(quat_error.Data);
quat_err_norm = zeros(1,len);
for kk = 1:len
    quat_err_norm(kk) = norm(quat_error.Data(kk,:));
end
plot(quat_error.Time,quat_err_norm,'linewidth',2)
title('Quaternion error $e(t) = 2\mathrm{acos}([q_e]_1(t))$')


% error quat
h5 = figure;
subplot(4,1,1)
plot(error_quat.Time, error_quat.Data(:,1),'r--')
ylabel('$q_1(t)$'), xlabel('t')
title('Error quaternion $q_e(t) = \hat q(t)^* \otimes q(t)$')

subplot(4,1,2)
plot(error_quat.Time, error_quat.Data(:,2),'b--')
ylabel('$q_2(t)$'), xlabel('t')

subplot(4,1,3)
plot(error_quat.Time, error_quat.Data(:,3),'k--')
ylabel('$q_3(t)$'), xlabel('t')

subplot(4,1,4)
plot(error_quat.Time, error_quat.Data(:,4),'g--')
ylabel('$q_4(t)$'), xlabel('t')


% cd figs
% 
% print(h1, '-depsc', strcat(filename,'omega.eps'))
% print(h2, '-depsc', strcat(filename,'quat.eps'))
% print(h3, '-depsc', strcat(filename,'bias.eps'))
% 
% cd ../


