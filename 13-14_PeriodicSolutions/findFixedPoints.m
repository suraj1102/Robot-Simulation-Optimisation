% Funcntion to find fixed points and return array of unique FPs
function fixed_points = findFixedPoints(samplingRange, numPoints, fixed_fun)
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
        
        % fixed_points = unique(fixed_points, 'rows');

        % filter unique rows within a tolerance
        fixed_points = uniquetol(fixed_points, 1e-3, 'ByRows', true);
    end

    [labels, clusters] = dbscan_clustering(fixed_points, 0.005, 5);
    filtered_points = clusterToFixedPoints(fixed_points, labels, clusters);

    fixed_points = filtered_points;
end

%% Filter Points 
function filtered_points = clusterToFixedPoints(points, labels, clusters)

    num_clusters = length(clusters);
    filtered_points = zeros(num_clusters, 2);

    for i = 1:num_clusters
        cluster_points = clusters{i};
        filtered_points(i, :) = mean(cluster_points, 1);
    end

    % Add noise points (label == -1)
    noise_points = points(labels == -1, :);
    filtered_points = [filtered_points; noise_points];
end

%% DBScan - Written by ChatGPT
function [labels, clusters] = dbscan_clustering(points, eps, minPts)

    if isempty(points)
        disp("No points to cluster");
        labels = [];
        clusters = {};
        return;
    end

    N = size(points, 1);
    
    labels = zeros(N, 1); % 0 = unvisited
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

    % Build clusters (cell array)
    clusters = {};
    for k = 1:cluster_id
        clusters{k} = points(labels == k, :);
    end

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
                neighbors = [neighbors; new_neighbors];
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
            neighbors = [neighbors; j];
        end
    end

end
