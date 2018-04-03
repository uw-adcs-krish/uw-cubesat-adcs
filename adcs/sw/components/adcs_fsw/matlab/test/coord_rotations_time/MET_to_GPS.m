%% MET to GPS conversion unit test
%
% UW HuskySat-1, ADCS Team
% T. Reynolds -- 3.9.18
%
% Test 1: Uses example 3-7 from Vallado 4e pp. 195-196. 
%   Date is May 14, 2004, 16:43:00.00
%
% Assumes sim_init.m has been run to set the paths.
% ----------------------------------------------------------------------- %
JD_J2000    = fsw_params.constants.time.JD_J2000;
day2sec     = fsw_params.constants.time.day2sec;

JD_TT           = 2453140.19727065; % from example
JD_J2000_TT     = JD_TT - JD_J2000;
JD_J2000_TT_s   = JD_J2000_TT * day2sec;

GPS_time    = JDTT_2_GPS( JD_J2000_TT_s );

% Convert this [y m d h m s] into GPS time and account for leap seconds
% Note: in 2004 we had TAI-UTC = 32.0. 
SoW_true    = 492180 + 32.0 - 19.0;
week_true   = 1270;

err     = norm(SoW_true-GPS_time(1)) + norm(week_true-GPS_time(2));