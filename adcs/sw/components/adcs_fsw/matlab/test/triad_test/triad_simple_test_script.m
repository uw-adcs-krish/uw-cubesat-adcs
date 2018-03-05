% run sim init before starting this script
clc; close all;
set(0,'defaulttextinterpreter','latex');
%cd /media/sexymathemagician/LaCie1/Git/uw_cubesat_adcs/adcs/sw/components/adcs_fsw/matlab/test/triad_test/
%addpath(genpath(pwd))

rng(155);

figdir = strcat(pwd,'/figs/');
datadir = strcat(pwd,'/data/');


% inputs

thet = 25*pi/18;

%A = [0   -0.8 -0.6;
%     0.8 -3.6 0.48;
%     0.6 0.48 -0.64];

%quat_init = attitudeToQuat(A);

quat_init = [cos(0.5*thet) sin(0.5*thet)*ones(1,3)]';
quat_init = quat_init./norm(quat_init);

mag_vec_init = [4 1 -8]';
mag_vec_init = mag_vec_init/norm(mag_vec_init);

sun_vec_init = [9 -3 18]';
sun_vec_init = sun_vec_init/norm(sun_vec_init);

% body frame
A = quatToMatrix(quat_init);
fsw_params.estimation.ic.rt_mag_eci_est = A*mag_vec_init;
fsw_params.estimation.ic.rt_sun_eci_est = A*sun_vec_init;

% reference frame
fsw_params.estimation.ic.rt_mag_body = mag_vec_init;
fsw_params.estimation.ic.rt_sun_body = sun_vec_init;

R1 = A*mag_vec_init;
R2 = A*sun_vec_init;
r1 = mag_vec_init;
r2 = sun_vec_init;

S = R1/norm(R1);
s = r1/norm(r1);

M = cross(R1, R2)/norm(cross(R1, R2));
m = cross(r1, r2)/norm(cross(r1, r2));

A_brute_force = [S M cross(S,M)]*[s m cross(s,m)]';
%display(A_brute_force)

run_time    = '50';
mdl         = 'triad_simple_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

display(quat_out.Data(1,:)')
display(quat_init);

fprintf('note that the sign on the quaternion scalar part is different, we should assume only positive part\n')