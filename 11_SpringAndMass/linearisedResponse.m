% See trajectory and animation for a 2D spring mass system
clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 10;
timespan = [t0 tf];
speedupFactor = 5;
animation = 1;

% System Constants
p.m = 1;
p.g = 0;

p.b1 = 0;
p.b2 = 0;

p.d = 0; % drag coef

p.k1 = 1;
p.k2 = 1;
p.l1_0 = 1;
p.l2_0 = 1;

p.r1 = [-1; 0];
p.r2 = [1; 0];

% Initial Conditions
r0 = [-0.0000  -0.0399]';
r0 = r0 + [0.1, 0.1]';
v0 = [0; 0];
z0 = [r0; v0];

% RHS Handler function
RHS = @(t,z)  myRHS(t,z,p);

% Solver
sol = ode45(RHS, timespan, z0);

n = 10e3 + 1;
tarray = linspace(t0, tf, n);

zArray = deval(sol, tarray);
xArray = zArray(1, :);
yArray = zArray(2, :);

% Fixed Points
samplingRange = [-3, 3];
fixed_fun = @(z) myRHS(0, z, p);

fixed_points = findFixedPoints(samplingRange, 50, fixed_fun)

% Get Jacobian and find A from f(x) = A(x-x*)
z_fixed = [fixed_points(1, 1); fixed_points(1, 2); 0; 0]

getJacobianOptions = optimoptions("fsolve", "Display", "off");
[~, ~, ~, ~, J] = fsolve(@(z) RHS(0, z), z_fixed, getJacobianOptions);

A = J;
e = eig(A);
disp('Eigenvalues at Fixed Point:');
disp(e); 

dz0 = z0 - z_fixed;

linRHS = @(t, dz) A * dz;
linSol = ode45(linRHS, timespan, dz0); % pass dz0, not z0

zLinDeviationArray = deval(linSol, tarray);
zLinArray = z_fixed + zLinDeviationArray; % Shift back by z*

xLin = zLinArray(1,:);
yLin = zLinArray(2,:);

% Plotting Full Trajectory
figure("name", "Trajectory")

plot(p.r1(1), p.r1(2), 'g.', 'MarkerSize', 20, 'DisplayName', 'Anchor 1'); hold on;
plot(p.r2(1), p.r2(2), 'g.', 'MarkerSize', 20, 'DisplayName', 'Anchor 2'); hold on;

plot(xArray, yArray, 'r-.', 'LineWidth', 2, 'DisplayName','Nonlinear Trajectory'); hold on;
plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 30, 'DisplayName', 'Start'); hold on;
plot(xArray(end), yArray(end), 'y.', 'MarkerSize', 30, 'DisplayName', 'End');

plot(xLin, yLin, 'y--', 'LineWidth', 2, 'DisplayName', 'Linearized Trajectory');

circle(p.r1(1), p.r1(2), p.l1_0); hold on;
circle(p.r2(1), p.r2(2), p.l2_0);

plot([p.r1(1) xArray(end)], [p.r1(2) yArray(end)], 'w-', 'LineWidth', 1, 'HandleVisibility','off');
plot([p.r2(1) xArray(end)], [p.r2(2) yArray(end)], 'w-', 'LineWidth', 1, 'HandleVisibility', 'off');
if ~isempty(fixed_points)
    plot(fixed_points(:,1), fixed_points(:,2), 'm.', 'MarkerSize', 20, ...
        'LineWidth', 1, 'DisplayName', 'Fixed Point');
end

legend()


title('Spring Damper Mass Trajectory')
xlabel('x');
ylabel('y');
axis equal
grid on;
shg



% Animation
if animation == 0 
    return;
end

figure("name", "Animation of Trajectory")
hold on
grid on
xlabel('x')
ylabel('y')
title('Animation')

% Add padding around trajectory-based limits
xmin = min(xArray);
xmax = max(xArray);
ymin = min(yArray);
ymax = max(yArray);


minWidth = 2;
minHeight = 2;

if abs(xmax - xmin) < 1e-6
    xmin = xmin - minWidth/2;
    xmax = xmax + minWidth/2;
end

if abs(ymax - ymin) < 1e-6
    ymin = ymin - minHeight/2;
    ymax = ymax + minHeight/2;
end

% Padding
pad = 1;
xpad = pad * (xmax - xmin);
ypad = pad * (ymax - ymin);

axis equal
xlim([xmin - xpad, xmax + xpad]);
ylim([ymin - ypad, ymax + ypad]);


plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 30, 'DisplayName', 'Start'); hold on;

c1 = plot(p.r1(1), p.r1(2), 'g.', 'MarkerSize', 20); hold on;
c2 = plot(p.r2(1), p.r2(2), 'g.', 'MarkerSize', 20); hold on;

trajectoryData = plot(xArray(1), yArray(1), 'r-.', 'LineWidth', 2, 'DisplayName', 'Nonlinear Traj'); hold on;
linTrajectoryData = plot(xLin(1), yLin(1), 'y--', 'LineWidth', 2, 'DisplayName', 'Linear Traj'); hold on;
point = plot(xArray(1), yArray(1), 'y.', 'MarkerSize', 30); hold on;


circle(p.r1(1), p.r1(2), p.l1_0); hold on;
circle(p.r2(1), p.r2(2), p.l2_0);

rod1 = plot([p.r1(1) xArray(1)], [p.r1(2) yArray(1)], 'w-', 'LineWidth', 1);
rod2 = plot([p.r2(1) xArray(1)], [p.r2(2) yArray(1)], 'w-', 'LineWidth', 1);


starttime = tic;
t = 0;

while t < tf
    z_now = deval(sol, t);
    x_now = z_now(1);
    y_now = z_now(2);

    point.XData = x_now;
    point.YData = y_now;

    % Find index of t in tarray
    idx = find(tarray <= t, 1, 'last');
    trajectoryData.XData = xArray(1:idx);
    trajectoryData.YData = yArray(1:idx);
    linTrajectoryData.XData = xLin(1:idx);
    linTrajectoryData.YData = yLin(1:idx);

    rod1.XData = [p.r1(1) x_now];
    rod1.YData = [p.r1(2) y_now];
    rod2.XData = [p.r2(1) x_now];
    rod2.YData = [p.r2(2) y_now];

    t = toc(starttime) * speedupFactor;
    drawnow limitrate;
end



function h = circle(x,y,r)
    hold on
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'LineStyle','--', "Color", "#808080", 'HandleVisibility','off');
end