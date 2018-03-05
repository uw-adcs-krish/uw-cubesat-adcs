%% SC in Eclipse Unit Test
%   UW HuskySat-1, ADCS Subsystem
%   Author: T. Reynolds 
%   Last update: 2.23.18
% ----------------------------------------------------------------------- %
% Test 1: Uses SWISSCUBE ephemeris. Uses SGP4 to propagate the orbit and
% determine if a line of sight vector to the sun exists. This has a small
% patch where we lose the sun. 
%
% Test 2: Uses QUAKESAT ephemeris. USes SGP4 to propagate the orbit.
% QUAKESAT is a polar sun-sync orbit, so should always have a line of sight
% to the sun. 
%
%   - Plots show trajectory and mid point sun vector, and whether or
%      not the sc has a LoS to the sun.
%   - Ref. Vallado p. 301 and 279
%
% Test 3: Uses example 5-6 from Vallado 4e, pp 309. Spacecraft should be
% illuminated.
%
% Assumes sim_init.m has been run to set the paths.
% ----------------------------------------------------------------------- %
run_test = 1;

%% Begin Tests

% ----------------------------------------------------------------------- %
if( run_test == 1 )
% Test 1

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% ----- Overrides ----- %
REKM = 6378.135; % earth radius [km]
sgp4.tle_filename = 'SWISSCUBE.tle'; % the right TLE
[sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
fsw_params.bus.orbit_tle = sgp4.orbit_tle;
% convert Oct 1, 2018 19:00:00 to GPS time
sim_params.sensors.gps.start_sec    = 154800 + 37.0 - 19.0;
sim_params.sensors.gps.start_week   = 2021;
% ----- End Overrides ---- %

% Run sim
run_time = '86400';
mdl = 'sun_vector_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analysis

% Extract data
sc2sun_unit = logsout.getElement('sc2sun_unit').Values.Data;
sc_in_sun   = logsout.getElement('sc_in_sun').Values.Data;
sc_pos_eci  = logsout.getElement('pos_eci_km').Values.Data;
JD_ut1      = logsout.getElement('jd_j2000_ut1').Values.Data;

mid         = floor(length(tout)/2);
avg_sc2sun  = (2*REKM).*sc2sun_unit(mid,:); 

% figure(1), hold on
% for i = 1:length(sc2sun_unit_time)
% quiver3(0,0,0,sc2sun_unit(i,1),sc2sun_unit(i,2),sc2sun_unit(i,3))
% end
% xlabel('x-direction [km]')
% ylabel('y-direction [km]')
% zlabel('z-direction [km]')
% %saveas(gcf, strcat(figdir, 'sc_to_sun_unit_vector_test1'),'fig')

figure(2), hold on
[X, Y, Z]=sphere(100);
X=X.*REKM;
Y=Y.*REKM;
Z=Z.*REKM;
Earth_im = imread('Flat_earth_cds.jpg', 'jpg');
surf(X, Y, Z,'CData',flip(Earth_im,1),'FaceColor','texturemap','EdgeColor','none');
plot3(sc_pos_eci(:,1),sc_pos_eci(:,2),sc_pos_eci(:,3),'r','LineWidth',2)
quiver3(0,0,0,avg_sc2sun(1),avg_sc2sun(2),avg_sc2sun(3),'LineWidth',2)
xlabel('x-direction [km]')
ylabel('y-direction [km]')
zlabel('z-direction [km]')
%saveas(gcf, strcat(figdir, 'traj_visualization_test1'),'fig')

figure(3)
plot(tout,sc_in_sun)
xlabel('Time [s]')
ylabel('Spacecraft in sun')
title('Eclipses of 1 Day')
ylim([-0.5 1.5])
%saveas(gcf, strcat(figdir, 'sc_in_sun_test1'),'fig')

%save(strcat(datadir, 'workspace_test_1'))

% ----------------------------------------------------------------------- %
elseif( run_test == 2 )
% Test 2
clear variables; close all; clc

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% ----- Overrides ----- %
REKM    = 6378.135; % earth radius [km]
sgp4.tle_filename = 'QUAKESAT.tle'; % the right TLE
[sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
fsw_params.bus.orbit_tle = sgp4.orbit_tle;
% convert Oct 1, 2018 19:00:00 to GPS time
sim_params.sensors.gps.start_sec    = 154800 + 37.0 - 19.0;
sim_params.sensors.gps.start_week   = 2021;
% ----- End Overrides ---- %

% Run sim
run_time = '86400';
mdl = 'sun_vector_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Analysis

% Extract data
sc2sun_unit = logsout.getElement('sc2sun_unit').Values.Data;
sc_in_sun   = logsout.getElement('sc_in_sun').Values.Data;
sc_pos_eci  = logsout.getElement('pos_eci_km').Values.Data;
JD_ut1      = logsout.getElement('jd_j2000_ut1').Values.Data;

mid         = floor(length(tout)/2);
avg_sc2sun  = (2*REKM).*sc2sun_unit(mid,:); 

% figure(1), hold on
% for i = 1:length(sc2sun_unit_time)
% quiver3(0,0,0,sc2sun_unit(i,1),sc2sun_unit(i,2),sc2sun_unit(i,3))
% end
% xlabel('x-direction [km]')
% ylabel('y-direction [km]')
% zlabel('z-direction [km]')
% %saveas(gcf, strcat(figdir, 'sc_to_sun_unit_vector_test1'),'fig')

figure(2), hold on
[X, Y, Z]=sphere(100);
X=X.*REKM;
Y=Y.*REKM;
Z=Z.*REKM;
Earth_im = imread('Flat_earth_cds.jpg', 'jpg');
surf(X, Y, Z,'CData',flip(Earth_im,1),'FaceColor','texturemap','EdgeColor','none');
plot3(sc_pos_eci(:,1),sc_pos_eci(:,2),sc_pos_eci(:,3),'r','LineWidth',2)
quiver3(0,0,0,avg_sc2sun(1),avg_sc2sun(2),avg_sc2sun(3),'LineWidth',2)
xlabel('x-direction [km]')
ylabel('y-direction [km]')
zlabel('z-direction [km]')
%saveas(gcf, strcat(figdir, 'traj_visualization_test2'),'fig')

figure(3)
plot(tout,sc_in_sun)
xlabel('Time [s]')
ylabel('Spacecraft in sun')
title('Eclipses of 1 Day')
ylim([-0.5 1.5])
%saveas(gcf, strcat(figdir, 'sc_in_sun_test2'),'fig')

%save(strcat(datadir, 'workspace_test_2'))
% ----------------------------------------------------------------------- %
elseif( run_test == 3 )
% Test 3

% Load parameters for both flight software and simulation
fsw_params = init_fsw_params();
[sim_params,fsw_params] = init_sim_params(fsw_params);

% Overrides
JD          = 2449763.5;
J2000       = 2451545.0;
JD_cent     = (JD - J2000)/36525;
r_eci       = [ 0; -4464.696; -5102.509 ] * 1e3; % m
 
% Run sim
run_time = '1';
mdl = 'sun_vector_test';
load_system(mdl);
set_param(mdl, 'StopTime', run_time);
sim(mdl);

% Extract data and look at LoS
sc2sun = logsout.getElement('sc2sun_unit').Values.Data;
sc_in_sun   = logsout.getElement('sc_in_sun').Values.Data;
if( sc_in_sun == 1)
    disp('Spacecraft is illuminated')
else
    disp('Spacecraft is in eclipse')
end

end
