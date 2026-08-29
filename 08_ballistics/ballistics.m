clc; clear; close all;

% Params
p.m = 1; % kg
p.c = 1; % kg/s
p.g = 1; % m/s^2

t0 = 0; tf = 100;
tspan = [t0, tf];

% Initial Conditions
theta = deg2rad(45); % rad
v0 = 1; % m/s

r0 = [0; 0];
v0 = [v0 * cos(theta); v0 * sin(theta)];
z0 = [r0; v0];


% ODE Solver
RHS = @(t, z) myRHS(t, z, p);
event = @myEvent;

solverOptions = odeset('Events', event);
sol = ode45(RHS, tspan, z0, solverOptions);

n = 1e4;
tf = sol.x(end);
t = linspace(t0, tf, n);

z = deval(sol, t);
r = z(1:2, :);
x = r(1, :); y = r(2, :);

% Axis Limits
xmax = max(r(1, :)); xmin = min(r(1, :));
ymax = max(r(2, :)); ymin = min(r(2, :));

 % Make 10% bigger
xmax = xmax * 1.1;
ymax = ymax * 1.1;

% Plot Trajectory
figure("Name", "Cannonball Trajectory")
axis equal
hold on
grid on
xlim([xmin, xmax]); ylim([ymin, ymax]);

plot(r(1, :), r(2, :), "r-.", "LineWidth", 2);

% Calculate Some Metrics
range = x(end);
height = max(y);
timeTillDrop = tf;


% Animation
figure("Name", "Trajectory Animation")
axis equal
hold on
grid on
xlim([xmin, xmax]); ylim([ymin, ymax]);

trajectoryData = plot(x(1), y(1), "r-.", "LineWidth", 2);
hold on;
cannonball = plot(x(1), y(1), "y.", "MarkerSize", 20);

tic;
tSim = 0;
speedupFactor = 1;

while tSim <= tf
    zNow = deval(sol, tSim);
    xNow = zNow(1);
    yNow = zNow(2);

    cannonball.XData = xNow;
    cannonball.YData = yNow;

    % Find idx of tSim in tarray (t)
    idx = find(t <= tSim, 1, 'last');

    if ~isempty(idx)
        trajectoryData.XData = x(1:idx);
        trajectoryData.YData = y(1:idx);
    end

    drawnow limitrate

    tSim = toc * speedupFactor;
end

