function mag_pd_controller = init_mag_pd_controller( fsw_params )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%   Load the parameters for the PD reorientation controller aimed at the
%   magnetorquers only.
% Last Edited: T. Reynolds 3.29.18
% ----------------------------------------------------------------------- %

% Initial Conditions
mag_pd_controller.ic.rt_quat_in         = zeros(4,1);
mag_pd_controller.ic.rt_w_body_radps    = zeros(3,1);
mag_pd_controller.ic.rt_command_torque  = zeros(3,1);
mag_pd_controller.ic.rt_command_RPM     = zeros(3,1);
mag_pd_controller.ic.torque             = zeros(3,1);

% Sample time
mag_pd_controller.sample_time_s     = 1/10; % sample at 10 Hz

% Conversions
mag_pd_controller.rps_2_rpm     = fsw_params.constants.convert.radps_2_RPM;

J  = fsw_params.bus.inertia;

% Choose damping ratio and natural frequency
z   = 1;            % Critically damped
wn  = 0.02*2*pi;    % Small natural frequency

mag_pd_controller.p_gain  = -wn^2.*J;
mag_pd_controller.d_gain  = -2*wn*z.*J;

end


