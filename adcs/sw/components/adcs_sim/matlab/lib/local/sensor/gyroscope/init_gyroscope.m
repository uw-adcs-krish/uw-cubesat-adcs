%% Sim Gyroscope Model Init File
%   Husky-Sat1, ADCS Subsystem
%   T. Reynolds: 8.3.17

function gyro = init_gyroscope( fsw_params )


gyro.sample_time_s  = (1/100);      % [Hz]
% angle random walk
gyro.arw            = [0.00507082424476565;...
                       0.00624226202371945;...
                       0.00444673083574964] * fsw_params.constants.convert.deg2rad;  
% rate random walk
gyro.rrw            = [3.47050822882769;...
                       3.48144649747210;...
                       2.55751178420391] .* fsw_params.constants.convert.asec2rad;         
                  
gyro.resolution     = 1e-5;         % resolution of sensor
gyro.valid_pct      = 99;           % over 10 seconds
gyro.bias_init      = 0.5*(pi/180)*[1 1 1]';     % Initial bias

end