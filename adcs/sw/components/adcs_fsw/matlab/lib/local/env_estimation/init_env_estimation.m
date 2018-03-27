function env_estimation = init_env_estimation(fsw_params)
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initialize all parameters for the environment modeling contained in FSW
%
% T. Reynolds 3.6.18
% ----------------------------------------------------------------------- %

% Library Sample Time
env_estimation.sample_time_s    = fsw_params.sample_time_s;

% Rate Transition Initial Conditions
env_estimation.ic.gps_time      = fsw_params.environment.sgp4.ic.gps_time;
env_estimation.ic.orbit_tle     = fsw_params.environment.sgp4.orbit_tle;

% Initialize SGP4 library
env_estimation.orb_estimation   = ....
                            init_orb_estimation(fsw_params,env_estimation);
                        
% Initialze ground station prediction
env_estimation.gs_estimation    = init_gs_prediction(env_estimation);

% Initialize sun vector library
env_estimation.sun_estimation   = init_sun_estimation(env_estimation);

% Initialize magnetic fied library
env_estimation.mag_vec  = init_magnetic_field(env_estimation);

end