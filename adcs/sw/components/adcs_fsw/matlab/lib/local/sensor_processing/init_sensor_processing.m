function sensor_processing = init_sensor_processing( fsw_params )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initializes all sensor processing parameters to be used in FSW.
%
% T. Reynolds -- 3.15.18
% ----------------------------------------------------------------------- %

sensor_processing.MSP_SP.sample_time_s  = fsw_params.sample_time_s;
sensor_processing.fsw.sample_time_s     = fsw_params.sample_time_s;

% ----- Magnetometer ----- %
sensor_processing.magnetometer.bias             = [0 0 0]';
sensor_processing.magnetometer.process_matrix   = eye(3);
sensor_processing.magnetometer.sensor2body      = eye(3);
sensor_processing.magnetometer.sample_time_s    = (1/20); % Hz
% ------------------------ %

% ----- Gyro ----- %
sensor_processing.gyro.sensor2body  = eye(3);
sensor_processing.gyro.sample_time_s = (1/50); % Hz
sensor_processing.gyro.cutoff_freq  = 2*pi*1; % [rad/s]
sensor_processing.gyro.c_lpf        = ...
    tf([sensor_processing.gyro.cutoff_freq],...
                                   [1 sensor_processing.gyro.cutoff_freq]);
sensor_processing.gyro.d_lpf        = ...
    c2d(sensor_processing.gyro.c_lpf,sensor_processing.gyro.sample_time_s);
[sensor_processing.gyro.filter_num,sensor_processing.gyro.filter_den] = ...
                                  tfdata(sensor_processing.gyro.d_lpf,'v');
sensor_processing.gyro.filter_num   = sensor_processing.gyro.filter_num(2);
sensor_processing.gyro.filter_den   = sensor_processing.gyro.filter_den(2);
% ---------------- %

% ----- Sun Sensor ----- %
sensor_processing.sunsensor.bias            = [0 0 0]';
sensor_processing.sunsensor.process_matrix  = eye(3);
sensor_processing.sunsensor.sensor2body     = eye(3);
sensor_processing.sunsensor.sample_time_s   = (1/10); % Hz
% ---------------------- %

% ----- GPS Sensor ----- %
sensor_processing.gps   = init_gps_processing(fsw_params);
% ---------------------- %


% ----- Photodiodes ----- %
sensor_processing.photodiodes.sample_time_s  = (1/2); % Hz
% ---------------------- %

% ----- Rate Transition ----- %
sensor_processing.ic.out    = [ 0; 0; 0;        % faceinsun_body_unit
                                0; 0; 0; 0;     % sun_body_sunsensor + valid
                                0; 0; 0; 0;     % mag_body_T + valid
                                sensor_processing.gps.ic.all; % orbit_tle + GPS_time
                                0; 0; 0; 0];    % omega_radps + valid
% --------------------------- %                            

end

