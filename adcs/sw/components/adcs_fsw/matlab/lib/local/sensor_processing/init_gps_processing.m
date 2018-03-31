function [ gps ] = init_gps_processing( fsw_params )
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Initializes all parameters in the gps_processing library.
%
% T. Reynolds -- 2.28.18
% ----------------------------------------------------------------------- %

% Pull constants
KM2M    = fsw_params.constants.convert.KM2M;
dut1    = fsw_params.constants.time.dut1;
cent2JD = fsw_params.constants.time.cent2JD;
day2sec = fsw_params.constants.time.day2sec;

% Sensor sample time
gps.sample_time_s     = fsw_params.sample_time_s;

% Initialize positions in TEME, ECI and ECEF frames
gps.ic.time = fsw_params.environment.sgp4.ic.gps_time;
[gps.ic.pos_teme_km,gps.ic.vel_teme_kmps] = ...
                            TLE2ECI(fsw_params.environment.sgp4.orbit_tle);
                        
gps.ic.pos_teme_m   = KM2M*gps.ic.pos_teme_km;
gps.ic.vel_teme_mps = KM2M*gps.ic.vel_teme_kmps;

% get time values
[~,~,~,~,T_ut1_J2000,T_TT_J2000] = time_conversion(gps.ic.time,dut1);
gps.JD_J2000_TT     = T_TT_J2000 * cent2JD; % save for epoch initialization
gps.JD_J2000_TT_s   = gps.JD_J2000_TT * day2sec;

% get rotation matrices
[ecef_2_eci, ppef_2_veci, ~, teme_2_eci]  = ...
           coordinate_rotations(T_ut1_J2000, T_TT_J2000);
eci_2_ecef          = ecef_2_eci';  

% Transform the TEME pos/vel
gps.ic.pos_eci_m    = teme_2_eci * gps.ic.pos_teme_m;
gps.ic.vel_eci_mps  = teme_2_eci * gps.ic.vel_teme_mps;

gps.ic.pos_ecef_m   = eci_2_ecef * gps.ic.pos_eci_m;
gps.ic.vel_ecef_mps = eci_2_ecef * ( gps.ic.vel_eci_mps ...
                                       - ppef_2_veci * gps.ic.pos_ecef_m );

% Initial condition for sensor processing should be ECEF                                  
gps.ic.all    = [ gps.ic.pos_ecef_m; gps.ic.vel_ecef_mps; gps.ic.time; 1 ];


end

