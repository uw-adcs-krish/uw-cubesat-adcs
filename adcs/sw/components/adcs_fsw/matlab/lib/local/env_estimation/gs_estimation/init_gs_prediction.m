function gs_prediction = init_gs_prediction( env_estimation )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initialize all parameters for the sun vector estimation
%
% S. Rice 1/6/2018
%   - updated by T. Reynolds 3.6.18 (added initial conditions)
% ----------------------------------------------------------------------- %

% ----- Earth parameters ----- %
gs_prediction.fov_ang  = 30; % [degrees] must be in (-90,90)
% ---------------------------- %

% Sample time
gs_prediction.sample_time_s     = env_estimation.sample_time_s;

% Initial conditions
gs_prediction.ic.ecef_2_eci     = eye(3);
gs_prediction.ic.sc_pos_eci_m   = zeros(3,1);
gs_prediction.ic.sc_above_gs    = 0;
gs_prediction.ic.sc_in_fov      = 0;
gs_prediction.ic.sc2gs_unit     = zeros(3,1);

% UW Ground Station 
gs_prediction.latlon = [47.6553;-122.3035];
gs_prediction.alt   = 0.0;




end