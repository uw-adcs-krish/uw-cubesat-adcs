function [r_km,v_kmps,FLAG] = OEV2RV(orbit_tle)
% ----------------------------------------------------------------------- %
% HuskySat-1, ADCS Subsystem
% Last Update: T. Reynolds - 12.7.17
%
% Computes an inertial position and velocity from a set of orbital
% elements.
% #codegen
% ----------------------------------------------------------------------- %

% Constants
mu          = 398600.4418; % [km3/s2]
deg2rad     = pi/180;   
twopi       = 2 * pi;
day2sec     = 86400;

INC     = orbit_tle(4) * deg2rad; % Inclination [rad]           
RAAN    = orbit_tle(5) * deg2rad; % Right Ascension of the Ascending Node [rad]
ECC     = orbit_tle(6);           % Eccentricity [-]
AOP     = orbit_tle(7) * deg2rad; % Argument of periapsis [rad]
MNA     = orbit_tle(8) * deg2rad; % Mean anomaly [rad]
MNM     = orbit_tle(9) * (twopi / day2sec); % Mean motion [rad/s]

% Orbital elements
a = (mu/(MNM^2))^(1/3);     % Semi-major axis [km]    

% solve kepler's equation for true anomaly
[~,TRA,FLAG] = kepler(MNA,ECC);

if( ECC == 1 )
    FLAG    = -1;
end
slr     = a * (1 - ECC * ECC); % semi-latus rectum

c1      = sqrt(mu/slr);
c2      = 1 + ECC*cos(TRA);

r_PQW   = [ slr*cos(TRA)/c2; slr*sin(TRA)/c2; 0 ];
v_PQW   = [ -c1*sin(TRA); c1*(ECC + cos(TRA)); 0];

C       = rot3(-RAAN)*rot1(-INC)*rot3(-AOP);

r_km    = C*r_PQW;
v_kmps  = C*v_PQW;

end

function [E, TRA, FLAG] = kepler(MNA, ECC)
% ----------------------------------------------------------------------- %
% UW HuskySat-1, ADCS Subsystem
% T. Reynolds -- 3.9.18
%
% MNA is MeaN Anomaly
% ECC is ECCentricity
% TRA is TRue Anomaly
% E   is Eccentric Anomaly
%
% Solves Kepler's equation for elliptic orbits using Newton-Raphson
%
% ----------------------------------------------------------------------- %

% Constants
tol         = 1e-8;
twopi       = 2 * pi;
i_max       = 10;
FLAG        = 0;

% Project onto [-2pi,2pi]
if( abs(MNA) > twopi )
    MNA = sign(MNA)*twopi;
end

% Initial guess
if( (-pi < MNA && MNA < 0) || (MNA > pi) )
    E   = MNA - ECC;
else
    E   = MNA + ECC;
end

% Run Loop
Enew    = 1e6;
for i = 1:i_max
    den     = 1 - ECC*cos(E);
    if( abs(den) > tol ) % avoid dividing by zero
        Enew    = E + (MNA - E + ECC*sin(E))/den;
    else
        FLAG    = -1;
    end
    
    err     = abs(E - Enew);
    if( err < tol )
        break;
    end
    E   = Enew;
end

if( i == i_max )
    FLAG    = 1;
end

% Compute true anomaly
if( abs(1-ECC) < 1e-10 )
    TRA     = 0;
    FLAG    = -1;
else
    c1      = sqrt( (1 + ECC) / (1 - ECC) );
    temp    = c1 * tan(0.5*E);
    TRA     = mod(2 * atan(temp), 2*pi);
end

end


function C = rot1(x)
    C   = [ 1.0   0.0     0.0;
            0.0   cos(x)  sin(x);
            0.0  -sin(x)  cos(x) ];
end

function C = rot3(x)
    C   = [ cos(x)  sin(x)  0.0;
           -sin(x)  cos(x)  0.0;
            0.0     0.0     1.0 ];
end

