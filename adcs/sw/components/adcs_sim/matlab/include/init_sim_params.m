 function [sim_params,fsw_params] = init_sim_params(fsw_params)

% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team

% Define all parameters to be used by SIM here. This is the second file to
% be called by 'SimInit.m' to initialize simulation data for the full 'Main
% Simulation.slx'. 
%   Takes in already defined fsw_params so that sim values can be defined
%   using the fsw values

% Last Edited: T.Reynolds 2.10.18
% ----------------------------------------------------------------------- %

% ----- Spacecraft Parameters ----- %
sim_params.bus  = fsw_params.bus;
sim_params.MET  = init_MET(fsw_params);
% -----

% ----- Physical Bus Signal Emulators ----- %
sim_params.CAN  = init_CAN(sim_params);
% -----

% ----- Dynamics -----%
sim_params.dynamics = init_dynamics(fsw_params);
% -----

% ----- Sensors ----- %
% Magnetometer
sim_params.sensors  = init_sensors(fsw_params);
% -----

% ----- Actuators ----- %
sim_params.actuators    = init_actuators();
fsw_params.actuators.ppt    = init_ppt(fsw_params);
% -----

% ----- Environment ----- %
sim_params.environment  = init_environment(fsw_params);
% -----

% ----- SGP4 - Orbit Propagator ----- %
fsw_params.bus.orbit_tle = sim_params.environment.sgp4.orbit_tle;
% -----

% ----- Estimation ----- %
fsw_params.estimation   = init_extended_kalman_filter(sim_params);
% -----


% END Function  --------------------------------------------------------- %
