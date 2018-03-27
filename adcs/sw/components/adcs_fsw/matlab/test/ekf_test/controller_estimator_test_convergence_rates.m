%% EKF Estimator Test
% Test 2:
%   Provide static inertial vectors and random initial estimator states.
%   The controller should steer the estimated state the (static) commanded
%   state. Required estimator convergencence in under 60s.
%   Brute-force test over a bunch of quaternion initial conditions

% UW HuskySat-1, ADCS Subsystem
%   Primary: M. Hudoba de Badyn -- 03.10.18
%   Secondary: T. Reynolds      -- 3.12.18

% Note: Assumes sim_init.m has been run
clc; close all;
set(0,'defaulttextinterpreter','latex');
set(0,'defaultAxesFontSize',14)
%% Test 1

% figure name prefix
filename = 'convergence_test_';

% turn the controller on/off <=> 1/0; the gain block appears in "Dynamics
% Subsystem"
ctrlGain = 0;

% number of runs (initial estimate conditions)
nRuns = 50;

% seed the random initial conditions so you get the same stuff everytime
rng(155);

% Attitude conditions
quat_cmd = randn(4,1);
quat_cmd = quat_cmd/norm(quat_cmd);
sim_params.dynamics.ic.quat_init        = [1 0 0 0]';
fsw_params.estimation.ic.quat_est_init  = rand(4,1);

% Angular velocity
fsw_params.estimation.ic.rt_w_body_radps    = 0.1*randn(3,1);
sim_params.dynamics.ic.rate_init            = zeros(3,1);

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
sim_tol = deg2rad(2); % The requirement is 2deg within 60s.

stoppingTimes = zeros(1,nRuns);
quatKeep = zeros(4,nRuns);
for kk = 1:nRuns
    
    fprintf('iteration %i of %i\n', kk, nRuns);
    
    fsw_params.estimation.ic.quat_est_init  = randu_quat;
    quatKeep(:,kk) = fsw_params.estimation.ic.quat_est_init;

    % Run the test
    run_time    = '500';
    mdl         = 'controller_estimator_test_static';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    stoppingTimes(kk) = omega_hat.Time(end);
    fprintf('Converged after %f seconds\n', stoppingTimes(kk))
    
    if str2double(run_time) == stoppingTimes(kk)
        fprintf('Run %i did not converge in simulation time\n',kk);
    end
    
end

%% plot stuff

%cd ./figs

h1 = figure;
hist(stoppingTimes)
xlabel('frequency')
ylabel('convergence time')
%print(h1, '-depsc', strcat(filename, 'histogram.eps'))
title(sprintf('Estimator convergence time to %3.3f degree error',rad2deg(sim_tol)))

%cd ../