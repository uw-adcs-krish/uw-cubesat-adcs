%% Time and coord rotation unit test init file
% UW HuskySat-1, ADCS Subsystem
%
% Test 1: Coordinate rotation test for TEME to ECI. Runs the simulink file
% coord_rotations_test.slx using example from Vallado 4ed, pp 233-234. Compares
% the outputs against the values given in the book.
%
% Test 2: Coordinate rotation test for ECEF to ECI. Runs the simulink file
% coord_rotations_test.slx using example 3-15 from Vallado 4ed, pp 230-231. 
% Compares the outputs against the values given in the book.
%
% Test 3: Time conversion test. Uses the answer from Example 3-13 in 
% Vallado 4e pp 203 as a seed for the GPS time, which is then converted
% back and should recover the answer.
%
% Test 4: Time conversion test #2. Uses Example 3-7 in Vallado 4e pp 195 to 
% convert a given date-time in UTC to UT1 and TT time frames. 
%
% Primary Test: T. Reynolds 2.10.18
%% Assuming sim_init.m has been run
close all; clc
set(0,'defaulttextinterpreter','latex');

% Constants
JD_2_cent   = 1/(36525);
JD_2_sec    = 86400;
sec_2_JD    = 1/86400;
sec_2_cent  = 1/(86400*36525);
dut1        = 0.204241;
ut1_2_tt    = 32.184 + 32 + dut1;
JD_J2000    = 2451545.0;


% Choose test
run_test    = 1;

%% Test 1

if run_test == 1
t_end       = 1;
% ----- Inputs ----- %
% Test TEME to ECI
JD      = 182.78495062;
% initial vectors
rTEME   = [ -9060.47373569; 4658.70952502; 813.68673153 ];
vTEME   = [ -2.232832783; -4.110453490; -3.157345433 ];
% desired vectors
rECId   = [ -9059.9413786; 4659.6972000; 813.9588875 ];
vECId   = [ -2.233348094; -4.110136162; -3.157394074 ];
% ----- end inputs for TEME ---- %

% Run Sim
run_time    = num2str(t_end);
mdl         = 'TEME_2_ECI_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
% TEME
rECI_comp   = logsout.getElement('rECI_comp').Values.Data;
vECI_comp   = logsout.getElement('vECI_comp').Values.Data;
rERR        = norm(rECId - rECI_comp(1,:)');
vERR        = norm(vECId - vECI_comp(1,:)');

% ----- End Analysis ----- %
% TEME
disp('TEME to ECI test: ')
disp(['Position error is: ',num2str(1e3*rERR),' m | ', ...
        'Velocity error is: ',num2str(1e3*vERR),' m/s'])

%save('workspace-test-NAME.mat')

elseif run_test == 2

% Test ECEF to ECI
% ----- Inputs ----- %
% Date-time is 2004-04-06-07-51-27.946047 UT1
dut1    = -0.4399619;
s_frac  = 0.946047;                         % Fractional part of UT1 seconds
JD2     = 2453101.827396 + sec_2_JD*s_frac; % Converted date-time w/o fractional seconds online.
JD_ut1_cent     = JD_2_cent*(JD2 - JD_J2000);
JD_tt_cent      = 0.0426236319;             % From the example.
% initial vectors
rECEF   = [ -1033.4793830; 7901.2952754; 6380.3565958 ];
vECEF   = [ -3.225636520; -2.872451450; 5.531924446 ];
% desired vectors
rECId2  = [ 5102.508958; 6123.01152; 6378.136928 ];
vECId2  = [ -4.74322016; 0.79053650; 5.53375528 ];
% ----- end inputs for ECEF ----- %

% Run Sim
run_time    = num2str(t_end);
mdl         = 'ECEF_2_ECI_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ECEF
rECI_comp2  = logsout.getElement('rECI_comp2').Values.Data;
vECI_comp2  = logsout.getElement('vECI_comp2').Values.Data;
rERR2       = norm(rECId2 - rECI_comp2(1,:)');
vERR2       = norm(vECId2 - vECI_comp2(1,:)');

% ECEF
disp('ECEF to ECI test: ')
disp(['Position error is: ',num2str(1e3*rERR2),' m | ', ...
        'Velocity error is: ',num2str(1e3*vERR2),' m/s'])

%save('workspace-test-NAME.mat')

elseif run_test == 3
%% Test 3
t_end   = 0;
JD_des  = 2449877.3458762;
year    = 1995;
month   = 6;
day     = 8;
doy     = 159;
hour    = 20;
min     = 18;
sec     = 3;
sec_frac = 0.70370;

% Override dut1 for this date: http://maia.usno.navy.mil/ser7/finals.all
fsw_params.sensor_processing.gps.dut1 = -0.0187545;

% Convert this [y m d h m s] into GPS time and add account for leap secs
gps_week    = 804;
gps_sec     = 418683 + 37.0 - 19.0 + sec_frac - 1.0;

% override the initial GPS time
sim_params.environment.sgp4.gps_week_init   = gps_week;
sim_params.environment.sgp4.gps_sec_init    = gps_sec;

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'time_conv_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
time_ut1        = logsout.getElement('time_ut1').Values.Data;
JD_ut1          = logsout.getElement('JD_ut1').Values.Data;
JD_ut1_J2000    = logsout.getElement('JD_ut1_J2000').Values.Data;
JD_ut1_J2000_C  = logsout.getElement('T_UT1').Values.Data;
dec_year        = logsout.getElement('dec_year').Values.Data;
GPS_time        = logsout.getElement('GPS_time').Values.Data;
% ----- End Analysis ----- %

ymdhms      = time_ut1(:,:,1);
JD          = JD_ut1(1);

disp(['Computed date-time is: ',num2str(ymdhms(1)),'-',...
        num2str(ymdhms(2)),'-',num2str(ymdhms(3)),' -- ',...
        num2str(ymdhms(4)),':',num2str(ymdhms(5)),':',num2str(ymdhms(6)) ])
disp(['Julian Date is: ',num2str(JD)])

elseif run_test == 4
%% Test 4
t_end = 0;
% Define baseline time in UTC
year    = 2004;
month   = 5;
day     = 14;
hour    = 16;
min     = 43;
sec     = 13;

% Override dUT1: in Vallado Ex.
fsw_params.sensor_processing.gps.dut1    = -0.463326;

% Desired JD values in UT1 and TT
JD_UT1  = 2453140.196522415;
JD_TT   = 2453140.19727065;
T_UT1   = 0.043671100545;
T_TT    = 0.043674121031;

% Convert this [y m d h m s] into GPS time and account for leap seconds
% Note: in 2004 we had TAI-UTC = 32.0. 
gps_week    = 1270;
gps_sec     = 492180 + 37.0 - 19.0;

% override the initial GPS time
sim_params.environment.sgp4.gps_week_init   = gps_week;
sim_params.environment.sgp4.gps_sec_init    = gps_sec;

% Simulation parameters
run_time    = num2str(t_end);
mdl         = 'time_conv_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% ----- Analyze Results ----- %
time_ut1        = logsout.getElement('time_ut1').Values.Data;
JD_ut1          = logsout.getElement('JD_ut1').Values.Data;
JD_ut1_J2000    = logsout.getElement('JD_ut1_J2000').Values.Data;
T_UT1           = logsout.getElement('T_UT1').Values.Data;
dec_year        = logsout.getElement('dec_year').Values.Data;
GPS_time        = logsout.getElement('GPS_time').Values.Data;
T_TT            = logsout.getElement('T_TT').Values.Data;
% ----- End Analysis ----- %

ymdhms      = time_ut1(:,:,1);
JD          = JD_ut1(1);

disp(['Computed date-time in UT1 is: ',num2str(ymdhms(1)),'-',...
        num2str(ymdhms(2)),'-',num2str(ymdhms(3)),' -- ',...
        num2str(ymdhms(4)),':',num2str(ymdhms(5)),':',num2str(ymdhms(6)) ])
disp(['Julian Date is: ',num2str(JD)])

end