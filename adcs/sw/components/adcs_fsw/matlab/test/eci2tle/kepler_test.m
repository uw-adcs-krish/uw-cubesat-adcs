%% Kepler Function test
%
% UW HuskySat-1, ADCS Team
% T. Reynolds -- 3.9.18
%
% Test 1: Uses example 2-1 in Vallado to compute eccentric and true
% anomaly given mean anomaly and eccentricity
%
% Test 2: Uses Curtis Ex 3.2 to test the True anomaly given the same
% inputs.
%
% Test 3: Uses Curtis Ex 3.3 case (b)
%
% Test 4: Uses Curtis Ex 3.3 case (c)
%
% Assumes sim_init.m has been run to set the paths.
% ----------------------------------------------------------------------- %
clear variables
run_test = 4;


if( run_test == 1)
% Inertial vectors
MNA     = deg2rad(235.4); % rad
ECC     = 0.4;

% Compute orbital elements
[E,TRA,FLAG]     = kepler(MNA,ECC);

E   = rad2deg(E);

% True values 
E_true  = 220.512074767522; % deg
elseif( run_test == 2 )
    MNA     = 3.6029; % rad
    ECC     = 0.37255;
    
    [E,TRA,FLAG]    = kepler(MNA,ECC);
    
    E_true      = 3.4794;
    TRA_true    = deg2rad(193.2);
    
elseif( run_test == 3 )
    MNA     = 0.62749;
    ECC     = 0.24649;
    
    [E,TRA,FLAG] = kepler(MNA,ECC);
    
    E_true      = 0.80521;
    TRA_true    = deg2rad(57.423);
    
elseif( run_test == 4 )
    MNA     = 2.1587;
    ECC     = 0.24649;
    
    [E,TRA,FLAG] = kepler(MNA,ECC);
    
    E_true  = 2.3364;
    TRA_true    = deg2rad(143.36);
    
end



