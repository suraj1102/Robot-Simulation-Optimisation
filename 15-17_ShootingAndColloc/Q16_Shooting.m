% Boundary Value Problem via Shooting
clc; clear; close all;

% Find xdot = v0 to solve
% xddot = -1 
% BVP: x(0) = 0; x(1) = 0

%% Params
t0 = 0; tf = 1; tspan = [t0 tf];

x0 = 0;
xf = 0;

%% Step sizes via numPoints
h = 0.1;
numPoints = (tf - t0)./h + 1;

%% F(s) vs s
s_vals = linspace(-2, 2, numPoints + 1001); % adjust range if needed
F_vals = zeros(size(s_vals));

for i = 1:length(s_vals)
    F_vals(i) = F(s_vals(i), tspan, x0, xf, numPoints + 1001);
end

figure;
plot(s_vals, F_vals);
xlabel('s = v(0)');
ylabel('F(s) = x(1) - x_f');
title('Shooting Function F(s)');
grid on;

%% Solve BVP
s_guess = 0; % initial guess
objectiveFunc = @(s) F(s, tspan, x0, xf, numPoints);

fsolveOptions = optimoptions('fsolve', 'Display', 'off');
s_sol_fsolve = fsolve(objectiveFunc, s_guess, fsolveOptions);
s_sol = myNewton(objectiveFunc, s_guess);

% Final integration with correct slope
n_z0 = [x0; s_sol]
[tarray, n_zarray] = myEuler(@myRHS, tspan, n_z0, numPoints);

n_x = n_zarray(:,1);
n_v = n_zarray(:,2);

%% Plot
figure()
hold on
plot(tarray, n_x, DisplayName='Newton Method');
xlabel('t'); ylabel('x(t)');
title('BVP Solution via Shooting');
grid on;


%% Functions
function err = F(s, tspan, x0, xf, n)
    % initial state: [x; v]
    z0 = [x0; s];

    [~, z] = myEuler(@myRHS, tspan, z0, n);

    x_end = z(end,1);
    err = xf - x_end;
end

function dzdt = myRHS(~, z)
    % z = [x; v]
    dzdt = zeros(2,1);
    dzdt(1) = z(2);   % x' = v
    dzdt(2) = -1;     % v' = -1
end

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

function s_sol = myNewton(f, s_guess)
    tol = 1e-8;
    max_iter = 50;
    h = 1e-5; % Step size for finite difference derivative
    s = s_guess;

    for i = 1:max_iter
        fs = f(s);
        if abs(fs) < tol
            break;
        end
        
        df = (f(s + h) - fs) / h;
        s = s - fs / df;
    end
    s_sol = s;
end

