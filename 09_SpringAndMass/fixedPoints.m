%% Define System
clear; clc; close all;

% Euler Method to Solve an ODE
t0 = 0;
tf = 5;
timespan = [t0 tf];

% System Constants
p.m = 1;
p.g = 0;

p.b1 = 1;
p.b2 = 1;

p.d = 1; % drag coef

p.k1 = 10;
p.k2 = 10;
p.l1_0 = 1.5;
p.l2_0 = 1.5;

p.r1 = [-1; 0];
p.r2 = [1; 0];

% Initial Conditions
r0 = [0; 0];
v0 = [0; 0];
z0 = [r0; v0];

%% Solver
% Handler functions
RHS = @(t,z)  myRHS(t,z,p);
fixed_fun = @(z) myRHS(0, z, p);

samplingRange = [-3, 3];
numPoints = 50;

x_vals = linspace(samplingRange(1), samplingRange(2), numPoints);
y_vals = linspace(samplingRange(1), samplingRange(2), numPoints);

fixed_points = [];

options = optimoptions("fsolve", ...
    "Display", "off");

for i = 1:length(x_vals)
    for j = 1:length(y_vals)
        
        % Keeping zero velocity
        z_guess = [x_vals(i); y_vals(j); 0; 0];
        [z_star, ~, exitflag, ~] = fsolve(fixed_fun, z_guess, options);
        if exitflag > 0
            % Keep only the position (x, y) and round to avoid duplicates
            fixed_points = [fixed_points; z_star(1:2)'];
        end
    end
end

% Extract unique points
if ~isempty(fixed_points)
    
    fixed_points = unique(fixed_points, 'rows');
    % % filter unique rows within a tolerance
    % fixed_points = uniquetol(fixed_points, 1e-4, 'ByRows', true);
end

%% Plotting Fixed Points
figure(); hold on; grid on;

plot(p.r1(1), p.r1(2), 'w.', 'MarkerSize', 20); hold on;
plot(p.r2(1), p.r2(2), 'w.', 'MarkerSize', 20); hold on;

circle(p.r1(1), p.r1(2), p.l1_0); hold on;
circle(p.r2(1), p.r2(2), p.l2_0);

if ~isempty(fixed_points)
    plot(fixed_points(:,1), fixed_points(:,2), 'yo', 'LineWidth', 2, 'DisplayName', 'Equilibrium');
    text(fixed_points(:,1)+0.1, fixed_points(:,2), 'Fixed Point');
end

xlabel('X Position'); ylabel('Y Position');
title('Fixed Points');
axis equal;



%% K-means and elbow plot
K_vals = 1:1:10;
maxIters = 100;
wcss_vals = zeros(length(K_vals), 1);

for K_idx = 1:length(K_vals)
    K = K_vals(K_idx);
    cluster_map = zeros(length(fixed_points), 1);
    initial_means = rand(K, 2);
    means = initial_means;
        
    for iterCount = 1:maxIters
        % Assignment Step
        for i = 1:length(fixed_points)
            distances = inf(K, 1);
            for k = 1:K
                distances(k) = norm(fixed_points(i, :) - means(k, :));
            end
            [~, idx] = min(distances);
            cluster_map(i) = idx;
        end
        
        % Update Step
        cluster_counts = zeros(K, 1);
        cluster_distance_sums = zeros(K, 2);
        
        for i = 1:length(fixed_points)
            point_cluster = cluster_map(i);
            cluster_counts(point_cluster) = cluster_counts(point_cluster) + 1;
            cluster_distance_sums(point_cluster, :) = cluster_distance_sums(point_cluster, :) + fixed_points(i, :);
        end
        
        for i = 1:K
            if cluster_counts(i) == 0
                means(i, :) = rand(1, 2) * max(samplingRange);
            else
                means(i, :) = cluster_distance_sums(i, :) ./ cluster_counts(i);
            end
        end
    end
    
    % Calculate WCSS
    wcss = zeros(K, 1);
    for i = 1:length(fixed_points)
        cluster = cluster_map(i);
        mean = means(cluster, :);
        distance = norm(mean - fixed_points(i, :))^2;
        wcss(cluster) = wcss(cluster) + distance;
    end
    wcss = sum(wcss);
    wcss_vals(K_idx) = wcss;
end

% Plot elbow plot
figure("Name","Elbow Plot")
plot(K_vals, wcss_vals, 'bo-')
xlabel("K")
ylabel("WCSS")
title("K-Means Elbow Method")

%% Plot Best K clustering results 
% figure();
% hold on;
% axis equal;
% grid on;
% 
[~, best_k_idx] = min(wcss_vals);
K = K_vals(best_k_idx);
disp("Best K: " + K);
% 
% colors = lines(K);
% 
% for k = 1:K
%     cluster_points = fixed_points(cluster_map == k, :);
%     scatter(cluster_points(:,1), cluster_points(:,2), ...
%             36, colors(k,:), 'filled');
% end
% 
% % Plot centroids
% scatter(means(:,1), means(:,2), 150, 'w', 'x', 'LineWidth', 2);
% 
% title(sprintf("K-Means Clustering (K = %d)", K));
% xlabel("X");
% ylabel("Y");
% 
% hold off;

%% Function Definitions
function h = circle(x,y,r)
    hold on
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'LineStyle','--', "Color", "#808080");
end
