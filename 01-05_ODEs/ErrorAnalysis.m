clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 10;

% System Constants
p.C1 = 2;
p.C2 = .4;

% Initial Conditions
z0 = 5;
p.z0 = z0;
p.numPoints = 0;
p.h = 0;

% Sweep numPoints, Solve ODE, find MAE
numPoints_array = 10.^(1:6) + 1;
errors = zeros(size(numPoints_array));
h_array = zeros(size(numPoints_array));
for i = 1:length(numPoints_array)
    tic
    p.numPoints = numPoints_array(i);
    p.h = (tf - t0) / (p.numPoints - 1);

    disp("Running test on numP = " + p.numPoints + ", h = " + p.h)
    [t, z] = EulerSolver(t0, tf, p.numPoints, p.h, p, z0);
    zExact = exactSol(t, p);
    
    % Find error
    errors(i) = mean(abs(z - zExact));
    h_array(i) = p.h;
    disp(toc)
end

loglog(h_array, errors, '-o', 'MarkerSize', 10)
xlabel('Step size h')
ylabel('Mean Absolute Error')
grid on


% Plotting
% figure(1)
% plot(t, z);
% hold on;
% plot(t, zExact);
% legend('Numerical solution', 'Exact solution')


function zdot = myRHS(z, t, p)
    zdot = z;
end

function zExact = exactSol(t, p)
    zExact = (p.z0 * exp(t))';
end

function [t, z] = EulerSolver(t0, tf, numPoints, h, p, z0)
    t = linspace(t0, tf, numPoints);
    z = zeros(numPoints, length(z0));
    
    z(1) = z0;
    
    for k = 1:numPoints - 1
        z_k = z(k); 
        t_k = t(k);
    
        z_dot = myRHS(z_k, t_k, p);
        z_next = z_k + z_dot * h;
    
        z(k+1) = z_next;
    end
end

