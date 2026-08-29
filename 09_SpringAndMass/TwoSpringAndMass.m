% See trajectory and animation for a 2D spring mass system
clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 30;
timespan = [t0 tf];

% System Constants
p.m = 1;
p.g = 0;

p.b1 = 1;
p.b2 = 1;;

p.d = 1; % drag coef

p.k1 = 10;
p.k2 = 10;
p.l1_0 = 1;
p.l2_0 = 1;

p.r1 = [-1; 0];
p.r2 = [1; 0];

% Initial Conditions
r0 = [-1; 0.001];
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


% Plotting Full Trajectory
figure("name", "Trajectory")

plot(p.r1(1), p.r1(2), 'g.', 'MarkerSize', 20); hold on;
plot(p.r2(1), p.r2(2), 'g.', 'MarkerSize', 20); hold on;

plot(xArray, yArray, 'r-.', 'LineWidth', 2); hold on;
plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 30); hold on;
plot(xArray(end), yArray(end), 'y.', 'MarkerSize', 30);

circle(p.r1(1), p.r1(2), p.l1_0); hold on;
circle(p.r2(1), p.r2(2), p.l2_0);

plot([p.r1(1) xArray(end)], [p.r1(2) yArray(end)], 'w-', 'LineWidth', 1);
plot([p.r2(1) xArray(end)], [p.r2(2) yArray(end)], 'w-', 'LineWidth', 1);

legend("R1", "R2", "Trajectory", "Start", "End")


title('Spring Damper Mass Trajectory')
xlabel('x');
ylabel('y');
axis equal
grid on;
shg



% Animation
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

xlim([xmin - xpad, xmax + xpad]);
ylim([ymin - ypad, ymax + ypad]);
axis equal


c1 = plot(p.r1(1), p.r1(2), 'g.', 'MarkerSize', 20); hold on;
c2 = plot(p.r2(1), p.r2(2), 'g.', 'MarkerSize', 20); hold on;

trajectoryData = plot(xArray(1), yArray(1), 'r-.', 'LineWidth', 2); hold on;
point = plot(xArray(1), yArray(1), 'y.', 'MarkerSize', 30); hold on;


circle(p.r1(1), p.r1(2), p.l1_0); hold on;
circle(p.r2(1), p.r2(2), p.l2_0);

rod1 = plot([p.r1(1) xArray(1)], [p.r1(2) yArray(1)], 'w-', 'LineWidth', 1);
rod2 = plot([p.r2(1) xArray(1)], [p.r2(2) yArray(1)], 'w-', 'LineWidth', 1);


starttime = tic;
speedupFactor = 10;
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
    h = plot(xunit, yunit, 'LineStyle','--', "Color", "#808080");
end