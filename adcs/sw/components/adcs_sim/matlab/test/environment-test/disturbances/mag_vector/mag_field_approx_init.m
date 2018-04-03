%% Magnetic vector unit test init file
% ----------------------------------------------------------------------- % 
% Compute data over 2 orbits to approximate magnetic field
%
% UW HuskySat-1, ADCS Subsystem
%  Last Update: T. Reynolds 3.31.18
% ----------------------------------------------------------------------- % 
run('sim_init.m')

% Overrides

% -----

t_end = 10800;

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'mag_field_approx';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% do least squares fit



%save('workspace-disturbances-test1.mat')

