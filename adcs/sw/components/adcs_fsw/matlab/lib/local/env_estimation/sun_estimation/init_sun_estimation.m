function sun_estimation = init_sun_estimation( env_estimation )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initialize all parameters for the sun vector estimation
%
%   Last Edited: T. Reynolds 8.3.17
% ----------------------------------------------------------------------- %

% Sample time
sun_estimation.sample_time_s    = env_estimation.sample_time_s;

% Initial conditions
sun_estimation.ic.JD_cent_ut1   = 0;
sun_estimation.ic.sc_pos_eci_m  = zeros(3,1);
sun_estimation.ic.sc_in_sun     = 0;
sun_estimation.ic.sc2sun_unit   = zeros(3,1);

end