%% SGP4 unit test init file
% ----------------------------------------------------------------------- %
% Test 1:
%   Compare my SGP4 propagation to data obtained from SWISSCUBE via STK
% Test 2:
%   Compare my SGP4 propagation to data obtained from QUAKESAT via STK
% Test 3:
%   Compare my SGP4 with example from Vallado (pp. 233-234)
%
% UW HuskySat-1, ADCS Subsystem
%  Last Update: T. Reynolds 3.6.18
%
% Note: Assumes sim_init.m has been run
% ----------------------------------------------------------------------- %

% Toggle the test to run here
run_test    = 1;


%% Test 1
if run_test == 1
    clear variables; close all
    % Load parameters for both flight software and simulation
    fsw_params = init_fsw_params();
    [sim_params,fsw_params] = init_sim_params(fsw_params);
    
    % Overrides
    sgp4.tle_filename = 'SWISSCUBE.tle'; % the right TLE
    [sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
    tle_array   = parse_tle(sgp4.tle_filename);
    fsw_params.bus.orbit_tle = sgp4.orbit_tle;
    
    % convert Oct 1, 2018 19:00:00 to GPS time
    sim_params.environment.sgp4.gps_sec_init   = 154800 + 37.0 - 19.0;
    sim_params.environment.sgp4.gps_week_init  = 2021;
    t_end   = 3*86400;
    % -----
    
    % Simulation parameters
    run_time    = num2str(t_end);
    mdl         = 'sgp4_unit_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % ----- Analyze Results ----- %
    flag    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag)
        if( flag(i) == -1 )
            error('Flag thrown during SGP4 operation')
        end
    end    
    %   extract pos/vel/time data from sim
    pos_eci_km = logsout.getElement('pos_eci_km').Values.Data;
    vel_eci_kmps = logsout.getElement('vel_eci_kmps').Values.Data;
    
    % pos_teme_km = logsout.getElement('pos_teme_km').Values.Data;
    % vel_teme_kmps = logsout.getElement('vel_teme_kmps').Values.Data;
    
    JD_J2000_days = logsout.getElement('JD_utc_J2000').Values;
    
    % import STK data
    load('SWISSCUBE_data.mat')
    x_km    = SWISSCUBE_data{1};
    y_km    = SWISSCUBE_data{2};
    z_km    = SWISSCUBE_data{3};
    pos_true_km     = horzcat(x_km,y_km,z_km);
    vx_kmps    = SWISSCUBE_data{4};
    vy_kmps    = SWISSCUBE_data{5};
    vz_kmps    = SWISSCUBE_data{6};
    vel_true_kmps   = horzcat(vx_kmps,vy_kmps,vz_kmps);
    
    % compare the beginning and end
    pos_diff_init   = norm(pos_eci_km(1,:) - pos_true_km(1,:));
    vel_diff_init   = norm(vel_eci_kmps(1,:) - vel_true_kmps(1,:));
    
    pos_diff_end    = norm(pos_eci_km(t_end,:) - pos_true_km(t_end,:));
    vel_diff_end    = norm(vel_eci_kmps(t_end,:) - vel_true_kmps(t_end,:));
    
    pos_drift_per_dt   = (pos_diff_end - pos_diff_init)/t_end;
    vel_drift_per_dt   = (vel_diff_end - vel_diff_init)/t_end;
    
    % plot trajectory
    REKM = 6378.135; % earth radius [km]
    figure(1), hold on
    [X, Y, Z]=sphere(100);
    X=X.*REKM;
    Y=Y.*REKM;
    Z=Z.*REKM;
    Earth_im = imread('Flat_earth_cds.jpg', 'jpg');
    surf(X, Y, Z,'CData',flip(Earth_im,1),'FaceColor','texturemap','EdgeColor','none');
    plot3(pos_eci_km(:,1),pos_eci_km(:,2),pos_eci_km(:,3),'r','LineWidth',1)
    plot3(x_km(1:t_end),y_km(1:t_end),z_km(1:t_end),'b','LineWidth',1)
    xlabel('x-direction [km]')
    ylabel('y-direction [km]')
    zlabel('z-direction [km]')
    
    % ----- End Analysis ----- %

%save('workspace-test-SWISSCUBE.mat')

elseif run_test == 2
    %% Test 2
    clear variables; close all
    % Load parameters for both flight software and simulation
    fsw_params = init_fsw_params();
    [sim_params,fsw_params] = init_sim_params(fsw_params);
    
    % Overrides
    sgp4.tle_filename = 'QUAKESAT.tle'; % the right TLE
    [sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
    fsw_params.bus.orbit_tle = sgp4.orbit_tle;
    
    % convert Oct 1, 2018 19:00:00 to GPS time
    sim_params.environment.sgp4.gps_sec_init   = 154800 + 37.0 - 19.0;
    sim_params.environment.sgp4.gps_week_init  = 2021;
    t_end  = 3*86400;
    % -----
    
    % Simulation parameters
    run_time    = num2str(t_end);
    mdl         = 'sgp4_unit_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % ----- Analyze Results ----- %
    flag    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag)
        if( flag(i) == -1 )
            error('Flag thrown during SGP4 operation')
        end
    end    
    %   extract pos/vel/time data from sim
    pos_eci_km = logsout.getElement('pos_eci_km').Values.Data;
    vel_eci_kmps = logsout.getElement('vel_eci_kmps').Values.Data;
    JD_J2000_days = logsout.getElement('JD_utc_J2000').Values.Data;
    
    % import STK data
    load('QUAKESAT_data.mat')
    x_km    = QUAKESAT_data{1};
    y_km    = QUAKESAT_data{2};
    z_km    = QUAKESAT_data{3};
    pos_true_km     = horzcat(x_km,y_km,z_km);
    vx_kmps    = QUAKESAT_data{4};
    vy_kmps    = QUAKESAT_data{5};
    vz_kmps    = QUAKESAT_data{6};
    vel_true_kmps   = horzcat(vx_kmps,vy_kmps,vz_kmps);
    
    % compare the beginning and end
    pos_diff_init   = norm(pos_eci_km(1,:) - pos_true_km(1,:));
    vel_diff_init   = norm(vel_eci_kmps(1,:) - vel_true_kmps(1,:));
    
    pos_diff_end    = norm(pos_eci_km(t_end,:) - pos_true_km(t_end,:));
    vel_diff_end    = norm(vel_eci_kmps(t_end,:) - vel_true_kmps(t_end,:));
    
    pos_drift_per_dt   = (pos_diff_end - pos_diff_init)/t_end;
    vel_drift_per_dt   = (vel_diff_end - vel_diff_init)/t_end;
    
    REKM = 6378.135; % earth radius [km]
    figure(1), hold on
    [X, Y, Z]=sphere(100);
    X=X.*REKM;
    Y=Y.*REKM;
    Z=Z.*REKM;
    Earth_im = imread('Flat_earth_cds.jpg', 'jpg');
    surf(X, Y, Z,'CData',flip(Earth_im,1),'FaceColor','texturemap','EdgeColor','none');
    plot3(pos_eci_km(:,1),pos_eci_km(:,2),pos_eci_km(:,3),'r','LineWidth',1)
    plot3(x_km(1:t_end),y_km(1:t_end),z_km(1:t_end),'b','LineWidth',1)
    xlabel('x-direction [km]')
    ylabel('y-direction [km]')
    zlabel('z-direction [km]')
    
    % ----- End Analysis ----- %
    
    %save('workspace-test-QUAKESAT.mat')

elseif run_test == 3
    %% Test 3
    clear variables; close all
    % Load parameters for both flight software and simulation
    fsw_params = init_fsw_params();
    [sim_params,fsw_params] = init_sim_params(fsw_params);
    
    % Overrides
    sgp4.tle_filename = 'vallado.tle'; % correct TLE
    [sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
    fsw_params.bus.orbit_tle = sgp4.orbit_tle;
    % convert Jun 29, 2000 08:23:17 to GPS time (account for leap seconds)
    sim_params.environment.sgp4.gps_sec_init   = 375797 + 37.0 - 19.0;
    sim_params.environment.sgp4.gps_week_init  = 1068;
    t_end   = 3*86400;
    % -----
    
    % Simulation parameters
    run_time    = num2str(t_end);
    mdl         = 'sgp4_unit_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % ----- Analyze Results ----- %
    flag    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag)
        if( flag(i) == -1 )
            error('Flag thrown during SGP4 operation')
        end
    end    
    %   extract pos/vel/time data from sim
    pos_eci_km      = logsout.getElement('pos_eci_km').Values.Data;    
    vel_eci_kmps    = logsout.getElement('vel_eci_kmps').Values.Data;
    
    % True ECI vectors
    pos_eci_end     = [ -9059.9413786, 4659.6972000, 813.9588875 ]; %km
    vel_eci_end     = [ -2.233348094, -4.110136162, -3.157394074 ]; %km/s
    
    pos_diff_end    = norm(pos_eci_km(end,:) - pos_eci_end);
    vel_diff_end    = norm(vel_eci_kmps(end,:) - vel_eci_end);
    
    % ----- End Analysis ----- %
    
    %save('workspace-test-vallado.mat')
    
end

