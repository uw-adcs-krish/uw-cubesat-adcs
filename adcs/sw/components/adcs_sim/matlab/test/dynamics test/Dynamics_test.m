%% DYNAMICS TEST %%

% Runs Simulink Dynamics_test_sim for user's chosen run time and initial
% conditions. Plots results for torque, angular velocity, quaternion
% attitude representation, linear accelaration, linear velocity and linear
% position. Samples values for quaternion, torque and angular
% velocity at different times to verify each point satisfies the
% fundamental differential equation. Quaternion derivative approximated
% using central differance scheme. Verification of simulation follows from 
% uniqueness theorem.

% Error Matrix displays the difference between the derivative of the
% quaternion/angular velocity computed using the differential equation that was modeled by
% the dymanics library, and the derivative of the quaternion/angular velocity computed using a
% centeral differance scheme on the result from simulation at each time
% step.

% Note: Rapid oscillations can cause the central difference to be less
% acurate and Error matrix should be taken with a grain of salt

% Original Author: R. Wallace

%Last test: 
%    E. Hansen,  3.28.2018
%-------------------------------------------------------------------------%

%Assumes sim_init has been run
clc

test = 4;
run_time = '1000';

% ------ INITIAL CONDITIONS ------ %

Run_time = str2double(run_time);

%Option 1:
if test == 1
    quaternion_init = [1,0,0,0];
    torque_init_const = [0,0,0];
    angular_rate_init_radps = [0,0,0];
    init_pos   = [0,0,0];
    init_vel   = [0,0,0];
    init_accel = [0,0,0];

%Option 2:
elseif test == 2
    quaternion_init = [1,0,0,0];
    torque_init_const = [0,0,0];
    angular_rate_init_radps = [0.001,0,0];
    init_pos   = [0,0,0];
    init_vel   = [0,0,0];
    init_accel = [0,0,0];
    
%Option 3:    
elseif test == 3
    quaternion_init = [1,0,0,0];
    torque_init_const = [-0.0000001,0,0];
    angular_rate_init_radps = [0.001,0,0];
    init_pos   = [1,0,0];
    init_vel   = [1,0,0];
    init_accel = [10,0,0];
  
 
%Option 4:    
elseif test == 4
    quaternion_init = [1,0,0,0];
    torque_init_const = [0.000001,-0.00001,0.000002];
    angular_rate_init_radps = [0.001,-0.02,-0.01];
    init_pos   = [2,0,0];
    init_vel   = [3,0,1];
    init_accel = [-10,5,0];
        
%Custom:  
elseif test == 5
    quaternion_init         = [1,0,0,0];
    torque_init_const       = [0,0,0];
    angular_rate_init_radps = [0.01,0,0];
    init_pos   = [1,1,-1];
    init_vel   = [1,0,2];
    init_accel = [0,0,20];
end     
        


%% TEST

%overriding sim_init initial conditions
dynamics = struct('ic',struct('quat_init',quaternion_init,'rate_init',angular_rate_init_radps));
sim_params = struct('CAN',sim_params.CAN,'dynamics',dynamics,'sensors',sim_params.sensors,'actuators',sim_params.actuators,'environment',sim_params.environment,'bus',sim_params.bus);
fsw_params.control.cmd_processing.ic.momentum = fsw_params.control.cmd_processing.ic.momentum.*fsw_params.convert.RPM_2_RADPS;
%the above momentum override is used because the updated command processing hasn't
%been pushed to develop yet
sim_params.environment.avg_b = [1.59212e-5 -6.1454e-6 4.0276e-5]; % T

%running simulation
model = 'Dynamics_test_sim';
load_system(model);
set_param(model, 'StopTime', run_time);
sim(model)

%plot results
close all;

position = logsout.getElement('position').Values.Data;
position_time = logsout.getElement('position').Values.Time;

velocity = logsout.getElement('velocity').Values.Data;
velocity_time = logsout.getElement('velocity').Values.Time;

accel = init_accel.*ones(Run_time,3);
accel_time = [1:length(accel(:,1))];

quaternion = logsout.getElement('quaternion').Values.Data;
quaternion_time = logsout.getElement('quaternion').Values.Time;

body_rates = logsout.getElement('body_rates').Values.Data;
body_rates_time = logsout.getElement('body_rates').Values.Time;

torque = torque_init_const.*ones(Run_time,3);
torque_time = [1:length(torque(:,1))];

hold on
figure(1)
title('Position(km)')
xlabel('Time(s)')
plot(position_time,position(:,1))
plot(position_time,position(:,2))
plot(position_time,position(:,3))

hold off
figure(2)
hold on
title('Velocity(kmps)')
xlabel('Time(s)')
plot(velocity_time, velocity(:,1))
plot(velocity_time, velocity(:,2))
plot(velocity_time, velocity(:,3))

hold off
figure(3)
hold on
title('Acceleration(mps2)')
xlabel('Time(s)')
plot(accel_time,accel(:,1))
plot(accel_time,accel(:,2))
plot(accel_time,accel(:,3))

hold off
figure(4)
hold on
title('Quaternion')
xlabel('Time(s)')
plot(quaternion_time,quaternion(:,1))
plot(quaternion_time,quaternion(:,2))
plot(quaternion_time,quaternion(:,3))
plot(quaternion_time,quaternion(:,4))

hold off
figure(5)
hold on
title('Angular Velocity(radps)')
xlabel('Time(s)')
plot(body_rates_time,body_rates(:,1))
plot(body_rates_time,body_rates(:,2))
plot(body_rates_time,body_rates(:,3))

hold off
figure(6)
hold on
title('Torque(Nm)')
xlabel('Time(s)')
plot(torque_time,torque(:,1))
plot(torque_time,torque(:,2))
plot(torque_time,torque(:,3))




%% Central Difference

%q' = 1/2 w * q
%w' = J^(-1)[L - w x (Jw) ]
%central difference q' = (q(x+h) - q(x-h))/(2h)


%write angular velocity as quaternion for differential equation

body_rates_quat = zeros(Run_time+1,4);
body_rates_quat(:,1) = zeros(Run_time+1,1);
body_rates_quat(:,2) = body_rates(:,1);
body_rates_quat(:,3) = body_rates(:,2);
body_rates_quat(:,4) = body_rates(:,3);

%initialize for loop
J = sim_params.bus.inertia;
Error = zeros(Run_time - 2, 7);
q_prime = zeros(Run_time - 2,4);
q_centraldifference = zeros(Run_time - 2,4);
w_prime = zeros(Run_time - 2,3);
w_centraldifference = zeros(Run_time - 2,3);

for i = [2:Run_time - 1]

    q_prime(i-1,:) = 1/2.*(quatmultiply(quaternion(i,:), body_rates_quat(i,:) ));
    q_centraldifference(i-1,:) = (quaternion(i+1,:)- quaternion(i-1,:))./(2*i);
    
    w_prime(i-1,:) = (J^(1)*( torque(i,:).' - cross( body_rates(i,:).',(J*body_rates(i,:).') ) )).';
    w_centraldifference(i-1,:) = (body_rates(i-1,:) - body_rates(i+1,:)   )/(2*i);
    
    Error(i-1,1:4) = q_prime(i-1,:) - q_centraldifference(i-1,:);
    Error(i-1,5:7) = w_prime(i-1,:) - w_centraldifference(i-1,:);

end

Error
disp('Largest error between exact derivative from fundamental differential equations and derivative from central difference.')
largest_error = norm(Error,Inf)
test
