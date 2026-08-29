close all; clear; clc;

close all; clear; clc;
%% Setup
p.g = 1.6;
p.t0 = 0;
p.tf_guess = 5; 
p.dt = 100e-3;
p.numPoints = p.tf_guess / p.dt; % N = 50 intervals

x0 = 5; xT = 0;
z0 = 10; zT = 0;
vx0 = -1; vxT = 0;
vz0 = -2; vzT = 0;
p.zinit = [x0, z0, vx0, vz0];
p.zfinal = [xT, zT, vxT, vzT];
p.R = diag([1, 1]);
p.Q = diag([1, 1, 1, 1]);
p.umax = 4;

[g, zinit, zfinal, numPoints] = unpack_p(p);

%% Run Trajectory Optimisation
N = numPoints;

% 4 variables: x,z,vx,vz which will have (N+1) points
% 2 control variables: ux, uz which will also have (N+1) points for
% trapezoidal discretisation
% Indexing: x  - 1          : N+1
%           z  - 1(N+1) + 1 : 2(N+1)
%           vx - 2(N+1) + 1 : 3(N+1)
%           vz - 3(N+1) + 1 : 4(N+1)
%           ux - 4(N+1) + 1 : 5(N+1)
%           vz - 5(N+1) + 1 : 6(N+1)
% The last element is our guess for the optimal final time T.

zfmin_guess = zeros(6*(N+1) + 1, 1); 
zfmin_guess(end) = p.tf_guess;

% Set bounds
lb = -inf(size(zfmin_guess));
lb(end) = 0.1; % T >= 0.1s
ub = inf(size(zfmin_guess));

cost = @(zfmin) costFunction(zfmin, p);
nonlcon = @(zfmin) constraintsFunction(zfmin, p);

fmincon_options = optimoptions('fmincon', ...
    'Algorithm','sqp', ...
    'MaxFunctionEvaluations', 1e6, ...
    'Display','iter');

[zfmin_opt,fval,exitflag,output] = ...
    fmincon(cost, zfmin_guess, [], [], [], [], lb, ub, ...
        nonlcon, fmincon_options);

if exitflag <= 0
    error("Solver Did not Converge");
end

plot_zfmin(zfmin_opt, p);
