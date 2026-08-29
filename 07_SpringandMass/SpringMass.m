% See trajectory and animation for a 2D spring mass system
clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 10;
timespan = [t0 tf];

% System Constants
p.m = 1; % Mass of bob (kg)
p.g = 10; % m/s^2
p.k = 10; % Spring coef (N/m)
p.l0 = 0; % Free Length of Spring (m)

% Initial Conditions
x = 1;
vx = 2;
y = 1;
vy = 2;
z_0 = [x; vx; y; vy];

% RHS Handler function
RHS = @(t,z)  myRHS(t,z,p);

% Solver
sol = ode45(RHS, timespan, z_0);

n = 10e2 + 1;
tarray = linspace(t0, tf, n);

zarray = deval(sol, tarray);
xArray = zarray(1, :);
vxArray = zarray(2, :);
yArray = zarray(3, :);
vyArray = zarray(4, :);


% Plotting Full Trajectory
figure("name", "Trajectory of Point Mass")
xmin = min(xArray); xmax = max(xArray);
ymin = min(yArray); ymax = max(yArray);
xlim([xmin-1 xmax+1]);
ylim([ymin-1 ymax+1]);
axis equal
grid on
hold on;

circle(0, 0, p.l0);
plot(xArray, yArray, "r-.", 'LineWidth', 2);
plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 20);
plot(xArray(end), yArray(end), 'g.', 'MarkerSize', 20);
plot([0 xArray(end)], [0 yArray(end)], 'w-', 'LineWidth', 1)


legend("FRee Length", "Trajectory", "Start", "End", "Rod");
title('Spring Mass Trajectory')
xlabel('x');
ylabel('y');
shg
hold off;



% Animation
set(gcf,'Renderer','opengl')
figure("name", "Animation of Trajectory of Point Mass")
hold on
axis equal
grid on
xlabel('x')
ylabel('y')
title('Spring Mass Animation')

xlim([xmin-1 xmax+1]);
ylim([ymin-1 ymax+1]);


circle(0, 0, p.l0);
trajectoryData = plot(xArray(1), yArray(1), 'r-.', 'LineWidth', 2);
startPoint = plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 20);
positionData = plot(xArray(1), yArray(1), 'g.', 'MarkerSize', 20);
rodData = plot([0 xArray(1)], [0 yArray(1)], 'w-', 'LineWidth', 1);

legend("Free Length", "Trajectory", "Start Point", "Cuurent Point", "Rod")

startTime = tic;      % start wall clock
speedupFactor = 2;    % >1 faster, <1 slower
while true
    simTime = toc(startTime) * speedupFactor;
    if simTime > tf
        break
    end

    % get state at current simulation time
    zNow = deval(sol, simTime);
    x = zNow(1);
    y = zNow(3);

    % find trajectory index up to current time
    idx = find(tarray <= simTime, 1, 'last');

    if ~isempty(idx)
        trajectoryData.XData = xArray(1:idx);
        trajectoryData.YData = yArray(1:idx);
    end

    % update position
    positionData.XData = x;
    positionData.YData = y;

    rodData.XData = [0 x];
    rodData.YData = [0 y];

    drawnow limitrate 
end

function h = circle(x,y,r)
    hold on
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'Color', "#808080", "LineStyle","--");
end