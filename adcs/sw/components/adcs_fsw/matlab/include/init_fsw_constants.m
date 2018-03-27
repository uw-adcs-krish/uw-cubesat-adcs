function [ constants ] = init_fsw_constants()
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Team
%
% Define constants used anywhere in FSW.
%
% T.Reynolds -- 2.28.17
% ----------------------------------------------------------------------- %

% Time
constants.time.dut1     = 0.0;
constants.time.dAT      = 37.0;
constants.time.gps2tai  = 19.0;
constants.time.gps2tt   = 32.184 + constants.time.gps2tai;
constants.time.gps2utc  = constants.time.gps2tai - constants.time.dAT;
constants.time.gps2ut1  = constants.time.gps2utc + constants.time.dut1;
constants.time.sec2day  = 1/86400;
constants.time.day2sec  = 86400;
constants.time.week2day = 7;
constants.time.JD_GPSepoch  = 2444244.5;
constants.time.JD_J2000     = 2451545.0;
constants.time.JD2cent      = 1/36525;
constants.time.cent2JD      = 36525;

% Conversions
constants.convert.KM2M  = 1e3;
constants.convert.M2KM  = 1e-3;
constants.convert.NT2T  = 1e-9;
constants.convert.RPM_2_radps   = (pi/30);
constants.convert.radps_2_RPM   = (30/pi);
constants.convert.deg2rad       = pi/180;
constants.convert.rad2deg       = 180/pi;
constants.convert.asec2rad      = 1/3600 * constants.convert.deg2rad;

% Misc.
constants.twopi     = 2*pi;
constants.o_prec    = 7.292115146706979e-5;


end

