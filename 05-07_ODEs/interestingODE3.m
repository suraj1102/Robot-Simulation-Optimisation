% See the solution of the Van der Pol oscillator
% Ref: https://en.wikipedia.org/wiki/Van_der_Pol_oscillator

clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 100;
timespan = [t0 tf];

% System Constants
p.mu = -.25;

% Initial Conditions
x0 = 1;
dotx0 = .3;
z_0 = [x0; dotx0];

% Solver params 
n = 100001;

% RHS Handler function
RHS = @(t,z)  myRHS(t,z,p);

% Solver
[tarray, zarray] = ODEEuler(RHS, timespan, z_0, n);

xArray = zarray(:,1);
dotxArray = zarray(:,2);

% Plotting states
plot(xArray, dotxArray)
title('Van der Pol Oscillator Solution Phase Plot')
xlabel('x');
ylabel('$\dot(x)$', 'Interpreter', 'latex');
shg



function  zdot = myRHS(t,z,p)
  mu = p.mu;

  z1 = z(1);
  z2 = z(2);

  % ODEs
  z1_dot =  z2;
  z2_dot =  (mu * (1 - z1^2) * z2) - z1;

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