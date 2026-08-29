clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 1;

% System Constants
p.C1 = 2;
p.C2 = .4;

% Initial Conditions
z0 = 1;
p.z0 = z0;
p.numPoints = 0;
p.h = 0;

% Sweep numPoints, Solve ODE, find MAE
numPoints_array = 10.^(1:8) + 1;
h_array = zeros(size(numPoints_array));

eul_errors = zeros(size(numPoints_array));
midp_errors = zeros(size(numPoints_array));

for i = 1:length(numPoints_array)
    p.numPoints = numPoints_array(i);
    p.h = (tf - t0) / (p.numPoints - 1);

    disp("Running test on numP = " + p.numPoints + ", h = " + p.h)
    [t, z_eul] = EulerSolver(t0, tf, p.numPoints, p.h, p, z0);
    [t, z_mid] = MidPointSolver(t0, tf, p.numPoints, p.h, p, z0);
    zExact = exactSol(t, p);
    
    % Find error
    eul_errors(i) = abs(z_eul(end) - zExact(end));
    midp_errors(i) = abs(z_mid(end) - zExact(end));
    h_array(i) = p.h;
end

loglog(h_array, eul_errors, '-o')
hold on
loglog(h_array, midp_errors, '-o')
xlabel('Step size h')
ylabel('Error')
legend('Euler Method', 'Midpoint Method');
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
    zExact = p.z0 * exp(t(:));
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

function [t, z] = MidPointSolver(t0, tf, numPoints, h, p, z0)
    t = linspace(t0, tf, numPoints);
    z = zeros(numPoints, length(z0));
    
    z(1) = z0;
    
    for k = 1:numPoints - 1
        z_k = z(k); 
        t_k = t(k);
    
        z_k_dot = myRHS(z_k, t_k, p);
        z_mid = z_k + z_k_dot * h / 2;
        z_mid_dot = myRHS(z_mid, t_k + (h / 2), p);
        
        z_next = z_k + z_mid_dot * h;
        
        z(k+1) = z_next;
    end
end

