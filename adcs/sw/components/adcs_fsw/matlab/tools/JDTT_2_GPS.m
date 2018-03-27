function [ GPS_time ] = JDTT_2_GPS( JD_J2000_TT_s )
% ----------------------------------------------------------------------- %
% Husky-Sat 1, ADCS Subsystem
% 
% Convert a JD_J2000_TT into the GPS epoch and SoW-Week.
%
%
% T. Reynolds -- 3.9.18
% ----------------------------------------------------------------------- %
% #codegen

% Constants
gps2tai     = 19.0;     % From MJD 58158
gps2tt      = 32.184 + gps2tai;
day2sec     = 86400; 
sec2day     = 1/day2sec;
dayinweek   = 7;
JD_GPSepoch = 2444244.5;
JD_J2000    = 2451545.0;

% Map input to JD_J2000_TT_days
JD_J2000_TT     = JD_J2000_TT_s * sec2day;

% Map input to GPS time frame
JD_J2000_GPS    = JD_J2000_TT - sec2day*gps2tt;
JD_GPS          = JD_J2000_GPS + JD_J2000;
JD_GPS_since_epoch    = JD_GPS - JD_GPSepoch;

% Convert to SoW and Week
week    = floor(JD_GPS_since_epoch/dayinweek);

sec_of_week    = day2sec * (JD_GPS_since_epoch - week*dayinweek);

GPS_time = [ sec_of_week; week ];

end

