function target_gen = init_target_generation( fsw_params )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initializes data for target generation library
%
% T. Reynolds 2.17.18
% ----------------------------------------------------------------------- %

target_gen.sample_time_s    = fsw_params.sample_time_s;

% Initial rate transition conditions
target_gen.ic.sc_mode   = 1;
target_gen.ic.quat      = [ 1; 0; 0; 0 ];
target_gen.ic.omega     = [ 0; 0; 0 ];
target_gen.ic.flag      = 0;

end

