%% main.m
clear; clc; close all;

% Time span
tspan = [0 5];

% Initial condition
x0 = 5;

% Solve using ode45
[t_num, x_num] = ode45(@myRHS, tspan, x0);

% Dense time for exact solution
t_exact = linspace(tspan(1), tspan(2), 200);
x_exact = myExact(t_exact);

% Plot
figure;
plot(t_num, x_num, 'b', 'LineWidth', 2); hold on;
plot(t_exact, x_exact, 'r--', 'LineWidth', 2);

xlabel('Time t');
ylabel('x(t)');
legend('ode45 Solution', 'Exact Solution');
title('$\dot{x} = -3x$,  $x(0) = 5$', 'Interpreter','latex');
grid on;


function dxdt = myRHS(t, x)
    dxdt = -3 * x;
end


function x = myExact(t)
    x = 5 * exp(-3 * t);
end