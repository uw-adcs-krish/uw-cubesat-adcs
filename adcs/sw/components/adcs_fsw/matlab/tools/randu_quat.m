%% randu_quat
% uniformly samples a unit quaternion with respect to the Haar measure
%
%
% UW HuskySat-1, ADCS Subsystem
% M. Hudoba de Badyn -- 03.10.18

function [ quat ] = randu_quat()

    u=rand(3,1);
    quat = [sin(2*pi*u(2))*sqrt(1-u(1));
            cos(2*pi*u(2))*sqrt(1-u(1));
            sin(2*pi*u(3))*sqrt(u(1));
            cos(2*pi*u(3))*sqrt(u(1))];

end

