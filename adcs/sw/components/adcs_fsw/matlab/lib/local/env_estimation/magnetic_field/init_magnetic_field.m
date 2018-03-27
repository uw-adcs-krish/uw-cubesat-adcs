function mag_vec = init_magnetic_field( env_estimation )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initialize all parameters for the environment modeling contained in FSW
%
% T. Reynolds 6.3.18
% ----------------------------------------------------------------------- %

% Sample time
if( nargin == 1 )
    mag_vec.sample_time_s     = env_estimation.sample_time_s;
end

% Initial conditions
mag_vec.ic.ecef_2_eci       = eye(3);
mag_vec.ic.pos_eci_m        = zeros(3,1);
mag_vec.ic.time_vec_ut1     = [2000; 1; 1; 0.0; 0.0; 0.0];
mag_vec.ic.mag_vec_eci_T    = zeros(3,1);
mag_vec.ic.mag_vec_eci_unit = zeros(3,1);

end