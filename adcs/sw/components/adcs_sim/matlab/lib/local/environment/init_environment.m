function environment = init_environment(fsw_params)
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initializes the whole environment block used in SIM.
%
%   Last Edited: T. Reynolds, 8.10.17
% ----------------------------------------------------------------------- %

% Initialize all sub blocks
environment.sol_p       = init_solar_pressure();
environment.aero_drag   = init_aero_drag();
environment.gravity     = init_gravity_field();
environment.magnetic    = init_magnetic_field();
environment.sgp4        = init_sgp4(fsw_params);
environment.sun_vector  = init_sun_vector();




end