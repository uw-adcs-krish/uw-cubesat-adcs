%% RV2OEV Function test
%
% UW HuskySat-1, ADCS Team
% T. Reynolds -- 3.6.18
%
%
% Description: Uses example 2-5 in Vallado to convert a given inertial 
% position and velocity to orbital elements.
%
% Assumes sim_init.m has been run to set the paths.
% ----------------------------------------------------------------------- %

% Inertial vectors
r_true   = [ 6524.834; 6862.875; 6448.296 ]; %km
v_true   = [ 4.901327; 5.533756; -1.976341 ]; %kmps

% Compute orbital elements
[INC,RAAN,ECC,AOP,MNA,MNM,FLAG] = RV2OEV(r_true,v_true);

% True values 
INC_true    = 87.870;
RAAN_true   = 227.898;
AOP_true    = 53.38;
ECC_true    = 0.832853;

% Convert back to inertial
orbit_tle   = [ 18; 0.0; 0.0; INC; RAAN; ECC; AOP; MNA; MNM ];
[r,v] = OEV2RV(orbit_tle);