% See states for a damped pendulum.

clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 12;
timespan = [t0 tf];

% System Constants
p.len = 1; % Length of pendulum (m)
p.mass = 0.1; % Mass of bob (kg)
p.g = 9.81; % m/s^2
p.gamma = 0.1; % Damping coef

% Initial Conditions
theta0 = pi/6; % Radians
dot_theta0 = pi/18; % Rad / sec
z_0 = [theta0; dot_theta0];

% Solver params 
n = 10001;

% RHS Handler function
RHS = @(t,z)  myRHS(t,z,p);

% Solver
[tarray, zarray] = ODEEuler(RHS, timespan, z_0, n);

thetaArray = zarray(:,1);
dot_thetaArray = zarray(:,2);

% Plotting states
plot(tarray, thetaArray, tarray, dot_thetaArray)
title('Pendulum Simulation')
xlabel('time');  
ylabel('States');
legend('\theta', '$\dot{\theta}$', 'Interpreter','latex')
shg



function  zdot = myRHS(t,z,p)
  l = p.len;  
  m = p.mass;
  g = p.g;
  y = p.gamma;
  

  c1 = 1 / (m * l * l);

  z1 = z(1);
  z2 = z(2);

  % ODEs
  z1_dot =  z2;
  z2_dot =  c1 * (-y*l*l * z2 + l*m*g * sin(z1));

    zdot = [z1_dot; z2_dot];
end


function  [tarray, zarray] = ODEEuler(funct, timespan, z0, n)
    t0 = timespan(1); 
    tf = timespan(2);
    neqns = length(z0);
    
    h = (tf - t0) / (n-1);
    
    tarray = linspace(t0, tf, n);
    zarray = zeros(n,neqns);
    zarray(1,:) = z0'; % z0 is col vec, make it a row vec
    znew = z0; % znew is a col vec
    
    
    for k = 1:n-1
        zold = znew;
        t = tarray(k);
        
        % Euler Method
        zdot = funct(t, zold);
        znew = zold + zdot * h;
        
        zarray(k+1,:) = znew'; % Convert back to row vec
    end
end