clear; clc; close;

% Euler Method to Solve an ODE
numPoints = 1001;

t0 = 0;
tf = 10;

% System Constants
p.C1 = 2;
p.C2 = .4;

% Initial Conditions
z1_0 = 1;
z2_0 = 0.5;
z0 = [z1_0; z2_0];

% Solver Params
h = (tf-t0) / numPoints;

t = linspace(t0, tf, numPoints);
z = zeros(numPoints, length(z0));

z(1, :) = z0;

for k = 1:numPoints - 1
    z_k = z(k, :)'; % Col Vector of states 
    t_k = t(k);

    z_dot = PhilAndSally(z_k, t_k, p);
    z_next = z_k + z_dot * h;

    z(k+1, :) = z_next';
end

% Plotting
figure(1)
z1 = z(:, 1);
z2 = z(:, 2);
plot(t, z1, t, z2);

figure(2)
plot(z1, z2);


function zdot = PhilAndSally(z, t, p)
    C1 = p.C1;
    C2 = p.C2;
    z1 = z(1);
    z2 = z(2);

    z1_dot = -z2 * C1;
    z2_dot = z1 * C2;
    zdot = [z1_dot; z2_dot];
end
