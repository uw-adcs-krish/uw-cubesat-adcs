function [ bus ] = init_bus_params()
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%   Initializes the parameters for the spacecraft bus.
%
% Last Edited: T.Reynolds 2.15.18
% ----------------------------------------------------------------------- %

% Physical Parameters
bus.mass    = 2.91084;  % [kg]
bus.dx      = 0.1;      % [m] x-axis length
bus.dy      = 0.1;      % [m] y-axis length
bus.dz      = 0.37;     % [m] z-axis length
bus.CoM     = [ -0.04952 -0.04492 0.18508 ]'; % [m] CoM location
bus.inertia = [ 0.033800072 -0.0000488358 -0.00007392968;
               -0.0000488358 0.03456792999 0.00000712402;
               -0.00007392968 0.00000712402 0.00742076536 ];
bus.solar_panel_unit = [0 0 1];
                      
% Moments of inertia (cuboid approximation)
% Ix = (fsw_params.sc.mass/12)*(fsw_params.sc.dy^2+fsw_params.sc.dz^2);    % X-axis inertia
% Iy = (fsw_params.sc.mass/12)*(fsw_params.sc.dx^2+fsw_params.sc.dz^2);    % Y-axis inertia
% Iz = (fsw_params.sc.mass/12)*(fsw_params.sc.dx^2+fsw_params.sc.dy^2);    % Z-axis inertia

% Other parameters
bus.quat.id             = [ 1; 0; 0; 0];
bus.RW_RPM_thresh.max   = 10e3;
bus.RW_RPM_thresh.min   = 2e3;
bus.omega_radps_thresh.max = 0.12;
bus.omega_radps_thresh.min = 0.00436; % 0.25 deg/s 
bus.bstar               = 3.2923e-5;        % drag term for SGP4 from SWISSCUBE
bus.sync_pulse          = 2;                % [s] minor sync pulse for duty cycling PPT
bus.dut1                = 0;                % SGP4 wants a UTC time
bus.vel_point_tol       = 12;               % degrees
end

