%% SGP4 Stress test init file
% ----------------------------------------------------------------------- %
% Test 1:   (a) Catch an error where eccentricity is >= 1
%           (b) Catch an error where eccentricity is <= 0
%           (c) Catch an error where mean motion is == 0
%
% Test 2:   Test catch condition #2 (see SGP4 source code)
%
% Test 3:   Test catch condition #3 (see SGP4 source code)
%
% Test 4:   Test catch condition #4 (see SGP4 source code)
%
% Test 5:   Test low altitude condition using a TLE from "SGP4 Orbit
% Determination", Vallado & Crawford, 2008. DOI: 10.2514/6.2008-6770.
%
% UW HuskySat-1, ADCS Subsystem
%   Primary: T. Reynolds -- 3.6.18
%
% Note: assumes sim_init.m has been run.
% ----------------------------------------------------------------------- %
clear variables; close all
% Load parameters for flight software and simulation
fsw_params                  = init_fsw_params();
[sim_params,fsw_params]     = init_sim_params(fsw_params);

% Load a TLE for this test
sgp4.tle_filename                   = 'SWISSCUBE.tle'; % the right TLE
[sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
fsw_params.bus.orbit_tle            = sgp4.orbit_tle;

% convert epoch of TLE (Oct 1, 2018 19:00:00) to GPS time
sim_params.environment.sgp4.gps_sec_init   = 154800 + 37.0 - 19.0;
sim_params.environment.sgp4.gps_week_init  = 2021;

% Toggle the test to run here
run_test = 5;

%% Test 1
if( run_test == 1 )
    % For test (a)
    test_TLE    = sgp4.orbit_tle;
    % Change the eccentricity manually
    test_TLE(6)     = 1;
    
    % run the test case
    t_end       = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_a    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_a)
        if( flag_a(i) == 0 )
            error('Did not catch eccentricity >= 1')
        end
    end
    
    % For test (b)
    test_TLE        = sgp4.orbit_tle;
    test_TLE(6)     = 0;
    % run the test case
    t_end       = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_b    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_b)
        if( flag_b(i) == 0 )
            error('Did not catch eccentricity <= 0')
        end
    end
    
    % For test (c)
    test_TLE        = sgp4.orbit_tle;
    test_TLE(9)     = 0;
    % run the test case
    t_end  = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_c    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_c)
        if( flag_c(i) == 0 )
            error('Did not catch mean motion == 0')
        end
    end
    
elseif( run_test == 2 )
    test_TLE    = sgp4.orbit_tle;
    % Do something to the TLE to test case #2.
    % >>> FILL THIS IN <<<
    
    % run the test case
    t_end  = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_c    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_c)
        if( flag_c(i) == 0 )
            error('Did not catch divide by zero in case #2')
        end
    end
    
elseif( run_test == 3 )
    test_TLE    = sgp4.orbit_tle;
    % Do something to the TLE to test case #3.
    % >>> FILL THIS IN <<<
    
    % run the test case
    t_end  = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_c    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_c)
        if( flag_c(i) == 0 )
            error('Did not catch divide by zero in case #3')
        end
    end
    
elseif( run_test == 4 )
    test_TLE    = sgp4.orbit_tle;
    % Do something to the TLE to test case #4.
    % >>> FILL THIS IN <<<
    
    % run the test case
    t_end  = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_c    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_c)
        if( flag_c(i) == 0 )
            error('Did not catch divide by zero in case #3')
        end
    end
    
elseif( run_test == 5 )
    % Load a TLE for this test
    sgp4.tle_filename                   = 'LOWPERIGEE.txt';
    [sgp4.orbit_tle,sgp4.JD_epoch_days] = get_tle(sgp4.tle_filename);
    fsw_params.bus.orbit_tle            = sgp4.orbit_tle;
    test_TLE    = sgp4.orbit_tle;
    % convert epoch of TLE (Jun 16, 2006 05:13:45.466) to GPS time
    sim_params.environment.sgp4.gps_sec_init   = 450784 + 37.0 - 19.0;
    sim_params.environment.sgp4.gps_week_init  = 1379;
        
    % run the test case
    t_end  = 1;
    run_time    = num2str(t_end);
    mdl         = 'sgp4_stress_test';
    load_system(mdl);
    set_param(mdl, 'StopTime', run_time);
    sim(mdl);
    
    % Analyze results
    flag_c    = logsout.getElement('SGP4_FLAG').Values.Data;
    for i = 1:length(flag_c)
        if( flag_c(i) == 0 )
            error('Did not catch low perigee case')
        end
    end
    
end


