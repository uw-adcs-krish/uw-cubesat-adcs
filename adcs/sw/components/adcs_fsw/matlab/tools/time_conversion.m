function [time_ut1,JD_utc_J2000,JD_ut1,JD_ut1_J2000,T_ut1_J2000,T_TT_J2000] = time_conversion(cur_gps,dUT1)
% ----------------------------------------------------------------------- %
% Husky-Sat 1, ADCS Subsystem
% 
% Convert a GPS time into date-time, Julian date and Julian century in the
% UT1 and TT frames. Accounts for leap seconds.
%
%   dUT1 obtained from:
%       http://maia.usno.navy.mil/ser7/finals.daily
%
% T. Reynolds -- 2.28.18
% ----------------------------------------------------------------------- %
% #codegen

% Constants
dAT         = 37.0;     % From MJD 58158 (Feb 7, 2018)
gps2tai     = 19.0;     % From MJD 58158
gps2tt      = 32.184 + gps2tai;
gps2utc     = gps2tai - dAT;
gps2ut1     = gps2tai - dAT + dUT1;
sec2day     = 1/86400; 
week2day    = 7;
JD_GPSepoch = 2444244.5;
JD_J2000    = 2451545.0;
JD2cent     = 1/36525;

sec_in = cur_gps(1); week_in = cur_gps(2);
% --------------------------- %

% Translate GPS w-s to JD and Gregorian ymd-hms
JD_days_gps     = JD_GPSepoch + week2day*week_in + sec2day*sec_in;
JD_utc          = JD_days_gps + sec2day*gps2utc;
JD_ut1          = JD_days_gps + sec2day*gps2ut1;
JD_TT           = JD_days_gps + sec2day*gps2tt;

JD_utc_J2000    = JD_utc - JD_J2000;
JD_ut1_J2000    = JD_ut1 - JD_J2000;
T_ut1_J2000     = JD_ut1_J2000*JD2cent;
T_TT_J2000      = JD2cent*( JD_TT - JD_J2000 );

time_ut1 = JD_2_ymdhms( JD_ut1 );

end

function [time] = JD_2_ymdhms( JD )
% This algorithm is based on Vallado 4e algorithm 22, pp 202.

% Constants
JD_1900     = 2415019.5;
Lmonth      = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

% Convert JD to date-time
T1900   = (JD - JD_1900)/365.25; % base epoch is 1900
year    = 1900 + floor(T1900);

leapyrs = floor((year - 1900 - 1)*0.25);
days    = (JD - JD_1900) - ((year - 1900)*365 + leapyrs );

if days < 1
    year    = year - 1;
    leapyrs = floor((year - 1900 - 1)*0.25);
    days    = (JD - JD_1900) - ((year - 1900)*365 + leapyrs );
end

if mod(year,4) == 0
    Lmonth(2) = 29;
end

dayofyear   = floor(days);

day     = 0;
month   = 0;

while day < dayofyear
    month   = month + 1;
    day = day + Lmonth(month);
end

%dayofmonth = dayofyear - (day - Lmonth(month));

tau     = 24*( days-dayofyear );
hour    = floor( tau );
min     = floor( 60*(tau - hour) );
sec     = 3600*( tau - hour - (min/60) );

time    = [ year, month, dayofyear, hour, min, sec ];
end


