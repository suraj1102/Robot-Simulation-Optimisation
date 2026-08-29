close all; clear; clc;

%% Setup
p.g = 1.6;

p.t0 = 0;
p.tf = 5;
p.tspan = [p.t0, p.tf];
p.dt = 100e-3; %100 ms
p.numPoints = p.tf / p.dt;

x0 = 5; xT = 0;
z0 = 10; zT = 0;

vx0 = -1; vxT = 0;
vz0 = -2; vzT = 0;

p.zinit = [x0, z0, vx0, vz0];
p.zfinal = [xT, zT, vxT, vzT];

p.R = diag([1, 1]);
p.Q = diag([0, 0, 0, 0]);
p.umax = 20;

[g, zinit, zfinal, numPoints, tspan] = unpack_p(p);

%% ODE45 - no control

% u = zeros(2, 1); % No control
% ode_fun = @(t, z) rhs(t, z, u, p);
% groundHitEvent = @(t, zall)touchGroundEvent(t, zall);
% 
% options = odeset('Events', groundHitEvent, 'RelTol', 1e-6, 'AbsTol', 1e-6);
% sol = ode45(ode_fun, tspan, zinit, options);
% 
% zall = sol.y;
% tarray = sol.x;
% 
% [x, z, vx, vz] = unpack_z(zall);
% 
% figure(); 
% tiledlayout(2, 1);
% 
% nexttile;
% hold on;
% plot(tarray, x, '- .', DisplayName="x")
% plot(tarray, z, '- .', DisplayName="z")
% plot(tarray, vx, '-. .', DisplayName="vx")
% plot(tarray, vz, '-. .', DisplayName="vz")
% xlabel("time")
% ylabel("position / veocity")
% legend();
% grid on;
% 
% nexttile; hold on;
% plot(x, z, '- .');
% grid on;
% title("Phase Plot / Lander Trajectory")
% xlabel("x")
% ylabel("z")


%% Run Trajectory Optimisation

% 4 variables: x,z,vx,vz which will have (N+1) points
% 2 control variables: ux, uz which will have N points
% Indexing: x  - 1          : N+1
%           z  - 1(N+1) + 1 : 2(N+1)
%           vx - 2(N+1) + 1 : 3(N+1)
%           vz - 3(N+1) + 1 : 4(N+1)
%           ux - 4(N+1) + 1 : 4(N+1) + N
%           vz - 4(N+1) + N + 1 : 4(N+1) + 2N

N = numPoints;
zfmin_guess = zeros( (4*(N+1)) + 2*N,  1 );
cost = @(zfmin) costFunction(zfmin, p);
nonlcon = @(zfmin) constraintsFunction(zfmin, p);
fmincon_options = optimoptions('fmincon', ...
    'Algorithm','sqp', ...
    'Display','iter', ...
    'UseParallel',false);

zfmin_opt = fmincon(cost, zfmin_guess, [], [], [], [], [], [], nonlcon, ...
    fmincon_options);

% plot_zfmin(zfmin_opt, p);

%% Controllable Region Estimation

% % Keep velocities and all other parameters fixed
% vx0_fixed = vx0;
% vz0_fixed = vz0;
% 
% % Sweep ranges
% xmin = -20;
% xmax = 20;
% 
% zmin = 0.001;
% zmax = 25;
% 
% numX = 10;
% numZ = 10;
% 
% xGrid = linspace(xmin, xmax, numX);
% zGrid = linspace(zmin, zmax, numZ);
% 
% feasible_points = [];
% infeasible_points = [];
% 
% for ix = 1:length(xGrid)
% 
%     for iz = 1:length(zGrid)
% 
%         % Current initial condition
%         x0_curr = xGrid(ix);
%         z0_curr = zGrid(iz);
% 
%         % Update problem initial state
%         p.zinit = [x0_curr, z0_curr, vx0_fixed, vz0_fixed];
% 
%         % Rebuild handles using same functions/practices
%         cost = @(zfmin) costFunction(zfmin, p);
%         nonlcon = @(zfmin) constraintsFunction(zfmin, p);
% 
%         % Same initialization
%         zfmin_guess = zeros( (4*(N+1)) + 2*N, 1 );
% 
%         try
% 
%             [zfmin_opt, ~, exitflag] = fmincon(cost, zfmin_guess, ...
%                 [], [], [], [], [], [], ...
%                 nonlcon, fmincon_options);
% 
%             is_feasible = exitflag > 0;
% 
%             if is_feasible
%                 feasible_points = [feasible_points; x0_curr, z0_curr];
%             else
%                 infeasible_points = [infeasible_points; x0_curr, z0_curr];
%             end
% 
%         catch
% 
%             infeasible_points = [infeasible_points; x0_curr, z0_curr];
% 
%         end
% 
%     end
% 
% end
% 
% % Plot feasible and infeasible regions
% 
% figure;
% hold on;
% grid on;
% 
% if ~isempty(feasible_points)
% 
%     scatter(feasible_points(:,1), feasible_points(:,2), ...
%         40, 'g', 'filled');
% 
% end
% 
% if ~isempty(infeasible_points)
% 
%     scatter(infeasible_points(:,1), infeasible_points(:,2), ...
%         40, 'r', 'filled');
% 
% end
% 
% xlabel('x_0');
% ylabel('z_0');
% 
% title('Controllable Region Estimation');
% 
% legend('Feasible', 'Infeasible');

%% Open loop execution
% openLoopExec(zfmin_opt, p);


%% MPC

% Unpack reference trajectory
[x_opt, z_opt, vx_opt, vz_opt, ux_opt, uz_opt] = unpack_zfmin(zfmin_opt, p);

% tf = 5, dt = 100 ms

tp_vals = [2];

for tp_idx = 1:length(tp_vals)
    p.tp = tp_vals(tp_idx); % Planning for tp second
    p.dtp = p.dt; % 100 ms of step size in planning
    p.Np = p.tp / p.dtp;
    Np = p.Np;
    
    alpha = [0.0, 0.0]; % Noise in control
    
    % Apply MPC Policy - Optimize, Apply First Control, Optimize, ...
    % MPC takes in all states and control, we apply only first control
    % (modified due to disturbance) and use our simulator to take a step
    % forward. 
    zinit = p.zinit;
    zmpc_guess = zeros( 4*(p.Np+1) + 2*Np,  1 );
    trajMPC = [];
    trajMPC = [trajMPC; p.zinit];
    controlMPC = [];
    for i = 1:numPoints
        costMPC = @(zmpc) MPCCostFunction(zmpc, zfmin_opt, p, i);
        constraintsMPC = @(zmpc) MPCConstraintsFunction(zmpc, p, zinit);
    
        zmpc = fmincon(costMPC, zmpc_guess, [], [], [], [], [], [], ...
            constraintsMPC, fmincon_options);
        
        [x, z, vx, vz, ux, uz] = unpack_zmpc(zmpc, p);
    
        if rand() < 0.5
            ux_applied = (rand()) * alpha(1) + ux(1);
            uz_applied = (rand()) * alpha(2) + uz(1);
        else
            ux_applied = ux(1);
            uz_applied = uz(1);
        end
        
        % ux_applied = alpha(1) * ux(1);
        % uz_applied = alpha(2) * uz(1);

        controlMPC = [controlMPC; ux_applied, uz_applied];
    
        zdot = rhs(0, [x(1), z(1), vx(1), vz(1)], [ux_applied, uz_applied], p);
        znext = p.dtp .* zdot;
        znext = znext' + [x(1), z(1), vx(1), vz(1)];
    
        trajMPC = [trajMPC; znext];
        
        zinit = znext;
        zmpc_guess = zmpc;
    end
    
    
    x = trajMPC(:, 1);
    z = trajMPC(:, 2);
    vx = trajMPC(:, 3);
    vz = trajMPC(:, 4);
    ux = controlMPC(:, 1);
    uz = controlMPC(:, 2);
    
    tarray = linspace(tspan(1), tspan(2), numPoints + 1);
     
    % Figure 1: State and Control Trajectories
    fig1 = figure();
    tiledlayout(3, 2);
    
    nexttile; hold on;
    plot(tarray, x_opt', '- .'); plot(tarray, x, '--.'); grid on;
    title("x"); xlabel("t"); legend('Optimal', 'Actual');
    
    nexttile; hold on;
    plot(tarray, z_opt', '- .'); plot(tarray, z, '--.'); grid on;
    title("z"); xlabel("t"); legend('Optimal', 'Actual');
    
    nexttile; hold on;
    plot(tarray, vx_opt', '- .'); plot(tarray, vx, '--.'); grid on;
    title("vx"); xlabel("t"); legend('Optimal', 'Actual');
    
    nexttile; hold on;
    plot(tarray, vz_opt', '- .'); plot(tarray, vz, '--.'); grid on;
    title("vz"); xlabel("t"); legend('Optimal', 'Actual');
        
    nexttile; hold on;
    plot(tarray(1:end-1), ux_opt', '- .'); plot(tarray(1:end-1), ux, '--.'); grid on;
    title("ux"); xlabel("t"); legend('Optimal', 'Actual');
    
    nexttile; hold on;
    plot(tarray(1:end-1), uz_opt', '- .'); plot(tarray(1:end-1), uz, '--.'); grid on;
    title("uz"); xlabel("t"); legend('Optimal', 'Actual');
    
    sgtitle(sprintf('MPC with Np: %d - State and Control Trajectories', p.Np));
    
    % Save Figure 1
    % filename1 = sprintf('imgs/MPC_Trajectories_Np_%d.png', p.Np);
    % saveas(fig1, filename1);
    
    % Phase Plot
    fig2 = figure();
    hold on;
    plot(x_opt, z_opt, '- .');
    plot(x, z, '--.');
    grid on;
    xlabel("x"); ylabel("z");
    title(sprintf('MPC with Np: %d - Phase Plot', p.Np));
    legend('Optimal', 'Actual');
    
    % Save Figure 2
    % filename2 = sprintf('imgs/MPC_PhasePlot_Np_%d.png', p.Np);
    % saveas(fig2, filename2);
    
    % Figure Absolute Error Trajectories
    fig3 = figure();
    tiledlayout(3, 2);
    
    nexttile; hold on; plot(tarray, abs(x_opt - x)', '-.'); grid on; title("error x"); xlabel("t");
    nexttile; hold on; plot(tarray, abs(z_opt - z)', '-.'); grid on; title("error z"); xlabel("t");
    nexttile; hold on; plot(tarray, abs(vx_opt - vx)', '-.'); grid on; title("error vx"); xlabel("t");
    nexttile; hold on; plot(tarray, abs(vz_opt - vz)', '-.'); grid on; title("error vz"); xlabel("t");
    nexttile; hold on; plot(tarray(1:end-1), abs(ux_opt - ux)', '-.'); grid on; title("error ux"); xlabel("t");
    nexttile; hold on; plot(tarray(1:end-1), abs(uz_opt - uz)', '-.'); grid on; title("error uz"); xlabel("t");
    
    sgtitle(sprintf('MPC with Np: %d - Absolute Error Trajectories', p.Np));
    
    % Save Figure 3
    % filename3 = sprintf('imgs/MPC_Error_Np_%d.png', p.Np);
    % saveas(fig3, filename3);
end

