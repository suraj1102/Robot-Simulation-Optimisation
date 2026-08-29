clear; clc; close all;

%% System Definition
A = [-1 0;
      0 1];

z0 = [6; 7];
tspan = [0 2];

%% Method 1: Eigen-decomposition solution
[V, D] = eig(A);   % A = V*D*V^{-1}

t_exact = linspace(tspan(1), tspan(2), 500);
z_exact = zeros(2, length(t_exact));

for i = 1:length(t_exact)
    t = t_exact(i);
    z_exact(:, i) = V * expm(D * t) * (V \ z0);
end

%% Method 2: Numerical solution using ode45
[t_num, z_num] = ode45(@(t,z) myRHS(t, z, A), tspan, z0);

%% Plot Time Series
figure;

subplot(2,1,1);
plot(t_num, z_num(:,1), 'b', 'LineWidth', 2); hold on;
plot(t_exact, z_exact(1,:), 'r--', 'LineWidth', 2);
ylabel('z_1');
legend('ode45','exact');
grid on;

subplot(2,1,2);
plot(t_num, z_num(:,2), 'b', 'LineWidth', 2); hold on;
plot(t_exact, z_exact(2,:), 'r--', 'LineWidth', 2);
ylabel('z_2');
xlabel('Time');
grid on;

%% Phase Plane Plot
figure;
plot(z_num(:,1), z_num(:,2), 'b', 'LineWidth', 2); hold on;
plot(z_exact(1,:), z_exact(2,:), 'r--', 'LineWidth', 2);
xlabel('z_1');
ylabel('z_2');
legend('ode45','exact');
title('Phase Plane');
grid on;

%% RHS Function
function dzdt = myRHS(~, z, A)
    dzdt = A * z;
end