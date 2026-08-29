clear; clc; close all;

xSamplingRange = [-1, 1];
ySamplingRange = xSamplingRange;
numPoints = 1000;

xArray = linspace(xSamplingRange(1), xSamplingRange(2), numPoints);
yArray = linspace(ySamplingRange(1), ySamplingRange(2), numPoints);

[X, Y] = meshgrid(xArray, yArray);
zSurface = mySurface(X, Y);
zPlane = myPlane(X, Y);

% Unit Circle Cylinder
theta = linspace(0, 2*pi, 100);
z_vals = linspace(-4, 4, 100);
[Theta, Zc] = meshgrid(theta, z_vals);
Xc = cos(Theta);
Yc = sin(Theta);


[X_minz, Y_minz, minZ] = gridSearch(X, Y, zSurface, zPlane, 1e-3);
disp("Gridsearch Minima(Z): X: " + X_minz + " Y: " + Y_minz + " Z: " + minZ);

[X_fmin, Y_fmin, Z_fmin] = fminconMinimize();
disp("Gridsearch Minima(Z): X: " + X_fmin + " Y: " + Y_fmin + " Z: " + Z_fmin);

% Plotting
figure()

hold on

surf(X, Y, zSurface, ...
    'EdgeColor', 'none', ...
    'FaceColor', 'b', ...
    'FaceAlpha', 0.6, ...
    'DisplayName', 'Surface');

surf(X, Y, zPlane, ...
    'EdgeColor', 'none', ...
    'FaceColor', 'r', ...
    'FaceAlpha', 0.7, ...
    'DisplayName', 'Plane');

surf(Xc, Yc, Zc, ...
    'EdgeColor', 'none', ...
    'FaceColor', 'g', ...
    'FaceAlpha', 0.3, ...
    'DisplayName', 'Unit Cylinder');

plot3(X_minz, Y_minz, minZ, ...
    'o', ...
    'MarkerSize', 10, ...
    'MarkerFaceColor', 'y', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1.5, ...
    'DisplayName', 'GridSerach Minimum');

plot3(X_fmin, Y_fmin, Z_fmin, ...
        'p', 'MarkerSize', 14, ...
        'MarkerFaceColor', 'y', ...
        'MarkerEdgeColor', 'k', ...
        'DisplayName', 'fmincon Minima');

grid on
legend()
xlabel('X')
ylabel('Y')
zlabel('Z')
view(45, 30)
rotate3d on


function z = mySurface(x, y)
    t1 = (x .* (x - y)).^2;
    t2 = -exp(-x.^2-y.^2);
    t3 = -cos(x);
    z = t1 + t2 + t3;
end

function z = myPlane(x, y)
    % x + y + z/3 = 0
    % z/3 = -x-y
    % z = -3(x+y)
    z = -3 .* (x + y);
end

function [X_minz, Y_minz, minZ] = gridSearch(X, Y, zSurface, zPlane, tol)
    % Matlab doesn't support default argumnets so this is the stupid syntax
    if nargin < 5
        tol = 1e-4;
    end

    [X_minz, Y_minz, minZ] = deal(inf);
    for i = 1:size(X, 1)
        for j = 1:size(X, 2)
            x_ij = X(i, j);
            y_ij = Y(i, j);
            z_ij_surf = zSurface(i, j);
            z_ij_plane = zPlane(i, j);

            
            if (abs(z_ij_plane - z_ij_surf) >= tol)
                continue
            end

            if (x_ij^2 + y_ij^2 > 1)
                continue
            end
            
            if (z_ij_plane >= minZ)
                continue
            end

            X_minz = x_ij;
            Y_minz = y_ij;
            minZ = z_ij_plane;
        end
    end

end


function [X_fmin, Y_fmin, Z_fmin] = fminconMinimize()
    obj = @(v) myPlane(v(1), v(2));
    nonlcon = @(v) deal( ...
        v(1)^2 + v(2)^2 - 1, ...
        mySurface(v(1), v(2)) - myPlane(v(1), v(2)) ...
    );
    
    v0 = [0, 0];
    
    [v_opt, z_opt] = fmincon(obj, v0, [], [], [], [], [], [], nonlcon);
    
    X_fmin = v_opt(1);
    Y_fmin = v_opt(2);
    Z_fmin = z_opt;    
end