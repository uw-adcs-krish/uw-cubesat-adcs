function p_dump = init_momentum_dump(fsw_params)
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%   Load the parameters for the momentum (p) unloading controller here. 
% Last Edited: E. Hansen 02.21.18
% ----------------------------------------------------------------------- %

% Initial Conditions
p_dump.ic.rt_rw_RPM         = zeros(3,1);
p_dump.ic.rt_mag_body_T     = zeros(3,1);
p_dump.ic.rt_dipole_Am2     = zeros(3,1);
p_dump.ic.rt_PPT_on         = 0;
p_dump.ic.rt_B_meas_valid   = 0;
p_dump.ic.delay_B           = [1.59212e-5 -6.1454e-6 4.0276e-5]; %Average magnetic field vector
p_dump.ic.rmp_setpoint_x    = 0;
p_dump.ic.rmp_setpoint_y    = 0;
p_dump.ic.rmp_setpoint_z    = 0;
I                           = fsw_params.actuators.reaction_wheel.inertia_matrix;
p_dump.ic.ang_mom_ref       = I*[p_dump.ic.rmp_setpoint_x*fsw_params.convert.RPM_2_RADPS;...
                                 p_dump.ic.rmp_setpoint_y*fsw_params.convert.RPM_2_RADPS;...
                                 p_dump.ic.rmp_setpoint_z*fsw_params.convert.RPM_2_RADPS]; %reference angular momentum of reaction wheels


% Sample time
p_dump.sample_time_s    = 1/5; % sample at 5 Hz

% Momentum unloading controller gains
p_dump.gain_k     = 1*10^(1);


