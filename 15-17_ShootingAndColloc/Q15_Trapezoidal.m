% Initial Value Problem (IVP) with collocation.
clc; clear; close all;

%% Params
t0 = 0; tf = 100; tspan = [t0 tf];

x0 = 0; v0 = 0.5;
z0 = [x0; v0];

%% Step sizes via numPoints
dt_list = [10 5 1 0.1, 0.001];
numPoints_list = (tf - t0)./dt_list + 1;

%% ODE
RHS = @(t, z) myODE(z);

%% Storage
results = struct();

for i = 1:length(numPoints_list)

    numPoints = numPoints_list(i);
    h = (tf - t0)/(numPoints - 1);

    % Euler
    [tE, zE] = myEuler(RHS, tspan, z0, numPoints);
    zE = zE';
    xE = zE(1,:); vE = zE(2,:);

    % Trapezoid
    [tT, zT] = myTrapezoid(RHS, tspan, z0, numPoints);
    zT = zT';
    xT = zT(1,:); vT = zT(2,:);

    results(i).h = h;
    results(i).tE = tE; results(i).xE = xE; results(i).vE = vE;
    results(i).tT = tT; results(i).xT = xT; results(i).vT = vT;
end

%% Single comparison plot
figure()

subplot(2,1,1) % Position
hold on
for i = 1:length(results)
    h = results(i).h;
    plot(results(i).tE, results(i).xE, '--', 'DisplayName', sprintf('Euler h=%.3g',h))
    plot(results(i).tT, results(i).xT, '-',  'DisplayName', sprintf('Trap h=%.3g',h))
end
grid on
title("Position Comparison (different h)")
xlabel("time"); ylabel("x")
legend show

subplot(2,1,2) % Velocity
hold on
for i = 1:length(results)
    h = results(i).h;
    plot(results(i).tE, results(i).vE, '--', 'DisplayName', sprintf('Euler h=%.3g',h))
    plot(results(i).tT, results(i).vT, '-',  'DisplayName', sprintf('Trap h=%.3g',h))
end
grid on
title("Velocity Comparison (different h)")
xlabel("time"); ylabel("v")
legend show

%% Functions
function  [tarray, zarray] = myEuler(funct, timespan, z0, n)
    t0 = timespan(1);
    tf = timespan(2);
    neqns = length(z0);

    h = (tf - t0) / (n-1);

    tarray = linspace(t0, tf, n);
    zarray = zeros(n,neqns);
    zarray(1,:) = z0'; % z0 is col vec, make it a row vec
    znew = z0; % znew is a col vec


    for k = 1:n-1
        zold = znew;
        t = tarray(k);

        % Euler Method
        zdot = funct(t, zold);
        znew = zold + zdot * h;

        zarray(k+1,:) = znew'; % Convert back to row vec
    end
end

function [tarray, zarray] = myTrapezoid(~, timespan, z0, n)
    % Only works for xddot = -1
    t0 = timespan(1);
    tf = timespan(2);
    neqns = length(z0);

    h = (tf - t0) / (n-1);

    tarray = linspace(t0, tf, n);
    zarray = zeros(n, neqns);
    zarray(1,:) = z0';

    znew = z0;

    for k = 1:n-1
        zold = znew;
        t = tarray(k);

        x = zold(1);
        v = zold(2);

        v_new = v + h * (-1);
        x_new = x + (h/2) * (v + v_new);

        znew = [x_new; v_new];
        zarray(k+1,:) = znew';
    end
end

function zdot = myODE(z)
    x = z(1);
    v = z(2);
    xdot = v;
    vdot = -1;
    zdot = [xdot; vdot];
end