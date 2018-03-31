 function [INC,RAAN,ECC,AOP,MNA,MNM,FLAG] = RV2OEV(r_km,v_kmps)
% Converts inertial position and velocity to classical orbital elements.
%   UW HuskySat-1, ADCS Subsystem
%   Updated: T. Reynolds 3.9.18
% #codegen

% Input

%  r_km = inertial position vector [kilometers]
%  v_kmps = inertial velocity vector [kilometers/second]

% Output

% INC   = orbital inclination [degrees]
% RAAN  = right ascension of ascending node [degrees]
% ECC   = orbital eccentricity [-]
% AOP   = argument of perigee [degrees]
% MNA   = mean anomaly [degrees]
% MNM   = mean motion [orbits/day]

% Reference:    -Spacecraft Dynamics and Control, M. Sidi. 
%               -Vallado 4e, Algorithm 9 pp 113-114.

% Constants
mu          = 398600.4418;      % km3/s2
small       = 1.0e-10;
twopi       = 2.0 * pi;
sinday      = 24 * 3600;
rad2deg     = 180.0 / pi;
RE          = 6378.137;         % Earth radius [km]
FLAG        = 0; % exit flag; flipped to -1 if there is a perceived error
r           = r_km;
v           = v_kmps;

% -------------------------  Implementation   --------------------------- %
magr = norm( r );
magv = norm( v );

% find h n and e vectors
hbar    = cross( r,v );
magh    = norm( hbar );
nbar    = [ -hbar(2); hbar(1); 0.0 ];
magn    = norm( nbar );
c1      = magv*magv - mu /magr;
rdotv   = dot( r,v );

% find eccentricity
ebar    = zeros(3,1);
for i = 1:3
    ebar(i)     = (c1*r(i) - rdotv*v(i))/mu;
end
ECC     = norm( ebar );
if( abs(ECC - 1.0) < small )
    FLAG = -1;
end

% find a e and semi-latus rectum 
sme     = ( magv*magv*0.5  ) - ( mu /magr );
if( (FLAG ~= -1) && (abs(sme) > small) )
    a   = -mu / (2.0 * sme);
else
    a   = Inf;
end
if( a < RE )
    FLAG = -1;
end

% find mean motion
MNM     = sqrt(mu/a^3);
MNM     = MNM/(twopi/sinday);

% find inclination 
hk      = hbar(3)/magh;
INC     = acos( hk );
if( INC < 0.0 )
    FLAG    = -1; 
end

% find longitude of ascending node 
RAAN    = 0.0;
if ( magn > small )
    temp = nbar(1) / magn;
    if ( abs(temp) > 1.0  )
        temp = sign(temp); % projects into [-1,1] for acos
    end
    RAAN = acos( temp );
    if ( nbar(2) < 0.0  )
        RAAN = twopi - RAAN;
    end
else
    FLAG    = -1;
end

% find argument of perigee
AOP     = 0.0;
temp = dot( nbar,ebar );
if( (magn > small) && (ECC > small) )
    temp2   = temp/(magn*ECC);
    if( abs(temp2) > 1.0 )
        temp2   = sign(temp2);
    end
    AOP     = acos(temp2);
else
    FLAG = -1;
end
if ( ebar(3) < 0.0  )
    AOP     = twopi - AOP;
end

% find true anomaly at epoch
nu      = 0.0;
temp    = dot( ebar,r );
if( (ECC > small) && (magr > small) )
    temp2   = temp/(ECC*magr);
    if( abs(temp2) > 1.0 )
        temp2   = sign(temp2);
    end
    nu  = acos(temp2);
else
    FLAG = -1;
end
if ( rdotv < 0.0  )
    nu  = twopi - nu;
end

% find mean anomaly for all orbits 
[~,MNA,FLAG] = newtonnu(ECC,nu,FLAG);

% Convert to degrees
INC     = rad2deg*INC;
RAAN    = rad2deg*RAAN;
AOP     = rad2deg*AOP;
MNA     = rad2deg*MNA;

end

function [e0,m,FLAG] = newtonnu ( ecc,nu,FLAG )

% Constants
e0      = 1e6;
m       = 1e6;
small   = 1e-8;

if( abs( ecc ) < small ) % circular 
    m   = nu;
    e0  = nu;
else % elliptical
    if( ecc < 1.0-small )
        sine    = (sqrt( 1.0 - ecc*ecc ) * sin(nu)) / (1.0 + ecc*cos(nu));
        cose    = (ecc + cos(nu)) / (1.0 + ecc*cos(nu));
        e0      = atan2( sine,cose );
        m       = e0 - ecc*sin(e0);
    else
        % For hyperbolic or parabolic orbits
        FLAG    = -1;
    end
end

if( ecc < 1.0 )
    m   = rem( m,2.0*pi );
    if( m < 0.0 )
        m   = m + 2.0*pi;
    end
    e0  = rem( e0,2.0*pi );
end

end

