clear; clc; close all;

%% Setup

problemODE = @rhsC;

% System Parameters
    % % Q13-A
    % p.k = 2;
    % p.m = 1;
    % 
    % % Q13-B
    % p.G = 1;
    % p.M = 1;
    
    % Q13-C to Q13-E
    p.k = 1;
    p.n = pi;
    
    % % Q13-F SpringMass
    % p.m = 1;
    % p.g = 0;
    % p.b1 = 0;
    % p.b2 = 0;
    % p.d = 0; % drag coef
    % p.k1 = 1;
    % p.k2 = 1;
    % p.l1_0 = 1;
    % p.l2_0 = 1;
    % p.r1 = [-1; 0];
    % p.r2 = [1; 0];

% Initial Conditions
r0 = [0.11; 10];
v0 = [-1; 9];
z0 = [r0; v0];
p.z0 = z0;


% Time Parameters
t0 = 0;
tf = 100;
timespan = [t0 tf];
numPoints = 1e4 + 1;
speedupFactor = 4;
animateFlag = 0;
p.numPoints = numPoints;
p.timespan = timespan;

simpleSolveODE = @(probelmODE, z0) solveODE(probelmODE, z0, p);
animate = @(zArray, tArray, sol) animateTrajectory(zArray, tArray, sol, p, [], speedupFactor);


%% Finding Period Motion

% Error Function, G = x(t) - x(t + T)
% Goal: Make G = 0
% Fixed: k,m,G,M, etc. 
% Unknown: r0, v0, T -> Find from root finding

T = 10;
numRuns = 20;
z0_guesses = repmat(p.z0, 1, numRuns) + 1*randn(length(p.z0), numRuns);
% z0_guesses = [
%     1 0 0 1;
%       10 0 0 10;
%    2.2374      0.033012     0.12357      1.2739
%    1 0 -1 1;
%    0.98339     -0.82008     0.052943      0.70435;
% ]';

results = struct();

for i = 1:numRuns
    z0_guess = z0_guesses(:, i);
    unknown0 = [z0_guess; T];
    p.z0 = z0_guess;

    periodic_fun = @(all_init) periodicResidualXY(all_init, problemODE, p);

    options = optimoptions('fsolve', ...
        'Display', 'off', ...
        'TolFun', 1e-10, ...
        'Algorithm', 'levenberg-marquardt');

    try
        solution = fsolve(periodic_fun, unknown0, options);

        z_periodic = solution(1:4);
        T_periodic = solution(5);

        % store results
        results(i).z0_guess = z0_guess;
        results(i).z_periodic = z_periodic;
        results(i).T_periodic = T_periodic;

    catch
        results(i).z0_guess = z0_guess;
        results(i).z_periodic = NaN;
        results(i).T_periodic = NaN;
    end
end


z0_guess_mat   = zeros(numRuns, 4);
z_periodic_mat = zeros(numRuns, 4);
T_vals         = zeros(numRuns, 1);
err_norm       = zeros(numRuns, 1);

for i = 1:numRuns
    z0g = results(i).z0_guess(:)';
    zp  = results(i).z_periodic(:)';
    T   = results(i).T_periodic;

    z0_guess_mat(i,:)   = z0g;
    z_periodic_mat(i,:) = zp;
    T_vals(i)           = T;

    % error = distance between guess and converged periodic state
    if any(isnan(zp))
        err_norm(i) = NaN;
    else
        err_norm(i) = norm(zp - z0g);
    end
end

% Create table
ResultTable = table( ...
    z0_guess_mat(:,1), z0_guess_mat(:,2), z0_guess_mat(:,3), z0_guess_mat(:,4), ...
    z_periodic_mat(:,1), z_periodic_mat(:,2), z_periodic_mat(:,3), z_periodic_mat(:,4), ...
    T_vals, err_norm, ...
    'VariableNames', { ...
    'z0_1','z0_2','z0_3','z0_4', ...
    'zp_1','zp_2','zp_3','zp_4', ...
    'T','ErrorNorm'});

disp(ResultTable)

% Plot Periodic Trajectory
try
    % z_periodic = [0.48371    0.020479      0.30061     2.8525];
    [zArrayPeriodic, tArray, solPeriodic] = simpleSolveODE(problemODE, z_periodic);
    plotTrajectory(zArrayPeriodic, tArray, [])
catch
end

%% Animate
[zArrayZ0, tArray, solZ0] = simpleSolveODE(problemODE, z_periodic);
plotTrajectory(zArrayZ0, tArray, [])
animate(zArrayZ0, tArray, solZ0)


%% ODE Solver
function [zArray, tArray, sol] = solveODE(problemODE, z0, p)
    timespan = p.timespan; t0 = timespan(1); tf = timespan(2); 
    n = p.numPoints;
    RHS = @(t, z) problemODE(z, p);

    options = odeset('RelTol', 1e-10, 'AbsTol', 1e-12);
    sol = ode45(RHS, timespan, z0, options);
    
    tArray = linspace(t0, tf, n);
    zArray = deval(sol, tArray);
end

function [xArray, yArray, vxArray, vyArray] = unpack(zArray)
    xArray = zArray(1, :);
    yArray = zArray(2, :);
    vxArray = zArray(3, :);
    vyArray = zArray(4, :);
end

%% Fixed Points
function fixed_points = getStaticFixedPoints(problemODE)
    samplingRange = [-10, 10];
    fixed_fun = @(z) problemODE(z, p);
    fixed_points = findFixedPoints(samplingRange, 50, fixed_fun);
end


%% Periodic Residuals
function error = periodicResidualX(all_init, problemODE, p)
    z0 = all_init(1:4);
    T = all_init(5);

    RHS = @(t, z) problemODE(z, p);
    sol = ode45(RHS, [0 T], z0);

    z_T = deval(sol, T);
    error = [
        z0 - z_T; % Return back to same point
        p.z0(1) - z_T(1); % Enforce x0_converged = x0
        % Use p.z0 as all_init passed into function changes as algo.
        % converges
    ];
end

function error = periodicResidualXY(all_init, problemODE, p)
    z0 = all_init(1:4);
    T = all_init(5);

    RHS = @(t, z) problemODE(z, p);
    sol = ode45(RHS, [0 T], z0);

    z_T = deval(sol, T);
    error = [
        z0 - z_T; % Return back to same point
        p.z0(1) - z_T(1); % Enforce x0_converged = x0 
        p.z0(2) - z_T(2); % Enforce x0_converged = x0
        % Use p.z0 as all_init passed into function changes as algo.
        % converges
    ];
end

function error = periodicResidualAllStates(all_init, problemODE, p)
    z0 = all_init(1:4);
    T = all_init(5);

    RHS = @(t, z) problemODE(z, p);
    sol = ode45(RHS, [0 T], z0);

    z_T = deval(sol, T);
    error = [
        z0 - z_T; % Return back to same point
        p.z0(1) - z_T(1); % Enforce x0_converged = x0 
        p.z0(2) - z_T(2); % Enforce y0_converged = y0
        p.z0(3) - z_T(3); % Enforce vx0_converged = vx0 
        p.z0(4) - z_T(4); % Enforce vy0_converged = vy0
        % Use p.z0 as all_init passed into function changes as algo.
        % converges
    ];
end


%% RHS Functions
function zdot = rhsA(z, p)
    % z = [r, v] = [x, y, vx, vy]
    k = p.k;
    m = p.m;
    
    r = z(1:2);
    v = z(3:4);

    r_dot = v;
    v_dot = -k/m .* r;

    zdot = [r_dot; v_dot];
end

function zdot = rhsB(z, p)
    % z = [r, v] = [x, y, vx, vy]
    G = p.G;
    M = p.M;
    
    r = z(1:2);
    v = z(3:4);

    norm_r = norm(r);

    r_dot = v;
    v_dot = -G*M/norm_r^3 .* r;

    zdot = [r_dot; v_dot];
end

function zdot = rhsC(z, p)
    % z = [r, v] = [x, y, vx, vy]
    k = p.k;
    n = p.n;
    
    r = z(1:2);
    v = z(3:4);

    r_mag = norm(r);

    r_dot = v;
    v_dot = -k * r_mag^(n-1) .* r;

    zdot = [r_dot; v_dot];
end

function  zdot = rhsSpringMass(z, p)
  m = p.m;
  g = p.g;

  b1 = p.b1;
  b2 = p.b2;
  d = p.d; % drag coef
  k1 = p.k1;
  k2 = p.k2;
  l1_0 = p.l1_0;
  l2_0 = p.l2_0;
  
  r1 = p.r1;
  r2 = p.r2;


  % States
  r = z(1:2); % Mass Position Vec
  v = z(3:4);


  % Unit Vectors
  i_hat = [1; 0];
  j_hat = [0; 1];
  
  l1 = norm(r - r1);
  lambda1_hat = (r - r1) / l1;

  l2 = norm(r - r2);
  lambda2_hat = (r - r2) / l2;

  % Spring K1
  F_k1 = k1 * (l1 - l1_0) * -lambda1_hat;
  F_k2 = k2 * (l2 - l2_0) * -lambda2_hat;

  % Check signs later from animation
  F_b1 = b1 * dot(v, lambda1_hat) * -lambda1_hat;
  F_b2 = b2 * dot(v, lambda2_hat) * -lambda2_hat;
   
  F_d = d * -v;
  
  W = m*g* -j_hat;

  F_net = F_k1 + F_k2 + F_b1 + F_b2 + F_d + W;
  a = F_net / m;

  
  % ODEs
  r_dot = v;
  v_dot = a;
    
  zdot = [r_dot; v_dot];
end



%% Plotting Functions
function plotTrajectory(zArray, tArray, fixed_points)
    [xArray, yArray, vxArray, vyArray] = unpack(zArray);
    
    figure()
    
    subplot(2, 4, [1, 2])
    hold on
    plot(xArray, yArray, 'c', "DisplayName", "Trajectory")
    plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 20, 'LineWidth', 2, "DisplayName", "Initial")
    plot(xArray(end), yArray(end), 'r.', 'MarkerSize', 20, 'LineWidth', 2, "DisplayName", "Final")
    
    if ~isempty(fixed_points)
        plot(fixed_points(:, 1), fixed_points(:, 2), 'y', 'Marker', '+', 'MarkerSize', 5, ...
           "DisplayName", "FP")
    end
    
    title("Position")
    xlabel("x"); ylabel("y")
    grid on
    axis equal
    legend()
    
    subplot(2, 4, [3, 4])
    hold on
    plot(vxArray, vyArray, 'y', "DisplayName", "Trajectory")
    plot(vxArray(1), vyArray(1), 'b.', 'MarkerSize', 20, 'LineWidth', 2, "DisplayName", "Initial")
    plot(vxArray(end), vyArray(end), 'r.', 'MarkerSize', 20, 'LineWidth', 2, "DisplayName", "Final")
    title("Velocity")
    xlabel("vx"); ylabel("vy")
    grid on
    axis equal
    legend()
    
    
    subplot(2,4,5)
    plot(tArray, xArray, 'c', 'LineWidth', 1.5)
    title("x vs t")
    xlabel("t"); ylabel("x")
    grid on
    
    subplot(2,4,6)
    plot(tArray, yArray, 'm', 'LineWidth', 1.5)
    title("y vs t")
    xlabel("t"); ylabel("y")
    grid on
    
    subplot(2,4,7)
    plot(tArray, vxArray, 'y', 'LineWidth', 1.5)
    title("vx vs t")
    xlabel("t"); ylabel("vx")
    grid on
    
    subplot(2,4,8)
    plot(tArray, vyArray, 'g', 'LineWidth', 1.5)
    title("vy vs t")
    xlabel("t"); ylabel("vy")
    grid on

end

function animateTrajectory(zArray, tArray, sol, p, fixed_points, speedupFactor)
    if isempty(fixed_points)
        fixed_points = [];
    end


    % Extract time span from solution
    t0 = p.timespan(1);
    tf = p.timespan(2);

    xArray = zArray(1, :);
    yArray = zArray(2, :);

    figure("name", "Animation of Trajectory")
    hold on
    grid on
    xlabel('x')
    ylabel('y')
    title('Animation')

    xmin = min(xArray); xmax = max(xArray);
    ymin = min(yArray); ymax = max(yArray);
    padding = 0.1;

    axis equal;
    xlim([xmin - padding, xmax + padding]);
    ylim([ymin - padding, ymax + padding]);

    traj_plot = plot(NaN, NaN, 'c', "DisplayName", "Trajectory");
    point_plot = plot(NaN, NaN, 'y.', 'MarkerSize', 15, "DisplayName", "Current");
    plot(xArray(1), yArray(1), 'b.', 'MarkerSize', 15, "DisplayName", "Initial");

    if ~isempty(fixed_points)
        plot(fixed_points(:, 1), fixed_points(:, 2), 'y+', ...
            'MarkerSize', 5, "DisplayName", "FP");
    end

    legend()

    starttime = tic;
    t = 0;

    while t < tf
        z_now = deval(sol, t);
        x_now = z_now(1); 
        y_now = z_now(2);

        idx = tArray <= t;
        set(traj_plot, 'XData', xArray(idx), 'YData', yArray(idx));
        set(point_plot, 'XData', x_now, 'YData', y_now);

        t = toc(starttime) * speedupFactor;
        drawnow limitrate;
    end
end


