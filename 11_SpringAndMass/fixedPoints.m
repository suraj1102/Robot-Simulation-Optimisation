% File to see what fixed points there are and perform clustering on them to
% get the right number of fixed points.

%% Define System
clear; clc; close all;

% Euler Method to Solve an ODE
t0 = 0;
tf = 5;
timespan = [t0 tf];

% System Constants
p.m = 1;
p.g = 1;

p.b1 = 1;
p.b2 = 1;

p.d = 1; % drag coef

p.k1 = 1;
p.k2 = 1;
p.l1_0 = 1;
p.l2_0 = 2;

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

plot(p.r1(1), p.r1(2), 'w.', 'MarkerSize', 20, 'DisplayName', 'Anchor 1'); hold on;
plot(p.r2(1), p.r2(2), 'w.', 'MarkerSize', 20, 'DisplayName', 'Anchor 1'); hold on;

circle(p.r1(1), p.r1(2), p.l1_0); hold on;
circle(p.r2(1), p.r2(2), p.l2_0);

if ~isempty(fixed_points)
    plot(fixed_points(:,1), fixed_points(:,2), 'y*', 'MarkerSize', 10, 'DisplayName', 'Fixed Point');
end

xlabel('X Position'); ylabel('Y Position');
title('Fixed Points');
legend();
axis equal;

kmeans(fixed_points, samplingRange);

dbscan = @(fixed_points, esp, minPts) dbscan_clustering(fixed_points, esp, minPts, p);
dbscan(fixed_points, 0.02, 5); 
% eps = 0.2 (distance threshold)
% minPts = 5 (density threshold)


%% K-means and elbow plot
function kmeans(fixed_points, samplingRange)
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
    grid on;
    

    % Select best k based on rate of change of wcss
    tol = 0.05; 
    improvement = -diff(wcss_vals) ./ wcss_vals(1:end-1);
    best_k_idx = find(improvement < tol, 1, 'first');
    
    % If no value is below tolerance, default to the absolute min
    if isempty(best_k_idx)
        [~, best_k_idx] = min(wcss_vals);
    end
    
    K = K_vals(best_k_idx);
    disp("Best K (with tolerance): " + K);

    title("K-Means Elbow Method | Best K: " + K)

end



%% DBScan - Written by ChatGPT

function dbscan_clustering(points, eps, minPts, p)
    if isempty(points)
        disp("No points to cluster");
        return;
    end

    N = size(points, 1);
    
    % Labels:
    % -1 = noise
    %  0 = unvisited
    %  1,2,... = cluster IDs
    labels = zeros(N, 1);
    cluster_id = 0;

    for i = 1:N
        if labels(i) ~= 0
            continue;
        end

        neighbors = regionQuery(points, i, eps);

        if length(neighbors) < minPts
            labels(i) = -1; % noise
        else
            cluster_id = cluster_id + 1;
            labels = expandCluster(points, labels, i, neighbors, cluster_id, eps, minPts);
        end
    end

    % Plotting
    figure(); hold on; grid on;
    title("DBSCAN Clustering of Fixed Points");

    plot(p.r1(1), p.r1(2), 'w.', 'MarkerSize', 20, 'DisplayName', 'Anchor 1'); hold on;
    plot(p.r2(1), p.r2(2), 'w.', 'MarkerSize', 20, 'DisplayName', 'Anchor 1'); hold on;
    
    circle(p.r1(1), p.r1(2), p.l1_0); hold on;
    circle(p.r2(1), p.r2(2), p.l2_0);

    unique_labels = unique(labels);
    colors = lines(length(unique_labels));

    for k = 1:length(unique_labels)
        label = unique_labels(k);
        idx = labels == label;

        if label == -1
            % Noise
            plot(points(idx,1), points(idx,2), 'k.', 'MarkerSize', 10, ...
                'DisplayName', 'Noise');
        else
            plot(points(idx,1), points(idx,2), '*', ...
                'Color', colors(k,:), ...
                'MarkerSize', 15, ...
                'DisplayName', sprintf('Cluster %d', label));
        end
    end

    xlabel('X'); ylabel('Y');
    legend();
    axis equal;
end


% Expand Cluster
function labels = expandCluster(points, labels, point_idx, neighbors, cluster_id, eps, minPts)

    labels(point_idx) = cluster_id;

    i = 1;
    while i <= length(neighbors)
        n_idx = neighbors(i);

        if labels(n_idx) == -1
            labels(n_idx) = cluster_id;
        end

        if labels(n_idx) == 0
            labels(n_idx) = cluster_id;

            new_neighbors = regionQuery(points, n_idx, eps);

            if length(new_neighbors) >= minPts
                neighbors = [neighbors; new_neighbors]; %#ok<AGROW>
            end
        end

        i = i + 1;
    end

end

% Region Query (find neighbors within eps)
function neighbors = regionQuery(points, idx, eps)

    N = size(points,1);
    neighbors = [];

    for j = 1:N
        if norm(points(idx,:) - points(j,:)) <= eps
            neighbors = [neighbors; j]; %#ok<AGROW>
        end
    end

end

%% Function Definitions
function h = circle(x,y,r)
    hold on
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit, 'LineStyle','--', "Color", "#808080", 'HandleVisibility','off');
end
