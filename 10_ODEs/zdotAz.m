clear; clc; close all;

%% System Definition
A = [3 1; 
     1 3];

z0 = [5; 0];

tspan = [0 2];

%% Numerical Solution using ode45
[t_num, z_num] = ode45(@(t,z) myRHS(t, z, A), tspan, z0);

%% Exact Solution
t_exact = linspace(tspan(1), tspan(2), 500);

v1 = [1; 1];
v2 = [1; -1];

lambda1 = 4;
lambda2 = 2;

C1 = 5/2;
C2 = 5/2;

z_exact = zeros(2, length(t_exact));

for i = 1:length(t_exact)
    t = t_exact(i);
    z_exact(:, i) = C1 * exp(lambda1 * t) * v1 + ...
                    C2 * exp(lambda2 * t) * v2;
end

%% Plot Time Series
figure;
subplot(2,1,1);
plot(t_num, z_num(:,1), 'b', 'LineWidth', 2); hold on;
plot(t_exact, z_exact(1,:), 'b--', 'LineWidth', 2);
ylabel('z_1');
legend('ode45', 'exact');

subplot(2,1,2);
plot(t_num, z_num(:,2), 'r', 'LineWidth', 2); hold on;
plot(t_exact, z_exact(2,:), 'r--', 'LineWidth', 2);
ylabel('z_2');
xlabel('Time');

%% Phase Plane Plot
figure;
plot(z_num(:,1), z_num(:,2), 'b', 'LineWidth', 2); hold on;
plot(z_exact(1,:), z_exact(2,:), 'r--', 'LineWidth', 2);
xlabel('z_1');
ylabel('z_2');
legend('ode45', 'exact');
title('Phase Plane');

%% RHS Function
function dzdt = myRHS(~, z, A)
    dzdt = A * z;
end