%% SGP4 Init File
%   UW DubSat-1 ADCS Subsystem
%   T. Reynolds, 5.20.2017

% Init file for sgp4 library
%% 
function sgp4   = init_sgp4()

    DEG2RAD         = pi/180;
    REVpD2RADpM     = 2*pi/1440;
    
%     sgp4.tle_filename = 'SWISSCUBE.tle';
    sgp4.tle_filename = 'QUAKESAT.tle'; % the right TLE';

    [sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);

    sgp4.y       = sgp4.orbit_tle(1);
    sgp4.jd_epoch_days   = sgp4.orbit_tle(2);
    sgp4.B_star  = sgp4.orbit_tle(3);
    sgp4.INC     = sgp4.orbit_tle(4)*DEG2RAD;       % [rad]
    sgp4.RAAN    = sgp4.orbit_tle(5)*DEG2RAD;       % [rad]
    sgp4.ECC     = sgp4.orbit_tle(6);               % [-]
    sgp4.AOP     = sgp4.orbit_tle(7)*DEG2RAD;       % [rad]
    sgp4.MNA     = sgp4.orbit_tle(8)*DEG2RAD;       % [rad]
    sgp4.MNM     = sgp4.orbit_tle(9)*REVpD2RADpM;   % [rad/min]
    
    % Estimated from epoch_jd using online converters. just used for test
    % sim 
    % DON'T CHANGE THE TLE W/O CHANGING THE GPS START TIME
    % SWISSCUBE and QUAKESAT have the same epoch
    sgp4.gps_sec_init   = 154800;
    sgp4.gps_week_init  = 2021; 
    
 




end