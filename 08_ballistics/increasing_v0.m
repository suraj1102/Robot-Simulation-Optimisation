clc; clear; close all;

% Params
p.m = 1; % kg
p.c = 1; % kg/s
p.g = 1; % m/s^2

t0 = 0; tf = 100;
tspan = [t0, tf];

% Initial Conditions
theta = deg2rad(45); % rad
v0_values = linspace(5, 100, 6);

figure("Name", "Cannonball Trajectories")
axis equal
hold on
grid on
xlabel("x")
ylabel("y")
title("Trajectories for Increasing v_0")

colors = lines(length(v0_values));

for i = 1:length(v0_values)
    
    vmag = v0_values(i);
    
    r0 = [0; 0];
    v0 = [vmag * cos(theta); vmag * sin(theta)];
    z0 = [r0; v0];
    
    RHS = @(t, z) myRHS(t, z, p);
    event = @myEvent;
    solverOptions = odeset('Events', event);
    
    sol = ode45(RHS, tspan, z0, solverOptions);
    
    n = 2000;
    tf_sol = sol.x(end);
    t = linspace(t0, tf_sol, n);
    
    z = deval(sol, t);
    r = z(1:2, :);
    
    plot(r(1, :), r(2, :), ...
        "LineWidth", 2, ...
        "Color", colors(i,:), ...
        "DisplayName", sprintf("v_0 = %.2f", vmag));
end

legend show