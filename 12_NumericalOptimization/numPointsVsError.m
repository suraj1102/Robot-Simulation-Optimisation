close all; clear; clc;

xSamplingRange = [-1, 1];
ySamplingRange = xSamplingRange;

numPointsArray = [50 100 200 400 800 1000, 2000, 4000, 6000, 10000, 12000, 14000, 16000];
ZErrorArray = zeros(size(numPointsArray));
distErrorArray = zeros(size(numPointsArray));

[X_fmin, Y_fmin, Z_fmin] = fminconMinimize(); % compute once

for k = 1:length(numPointsArray)

    numPoints = numPointsArray(k);

    xArray = linspace(xSamplingRange(1), xSamplingRange(2), numPoints);
    yArray = linspace(ySamplingRange(1), ySamplingRange(2), numPoints);

    [X, Y] = meshgrid(xArray, yArray);
    zSurface = mySurface(X, Y);
    zPlane = myPlane(X, Y);

    [X_minz, Y_minz, minZ] = gridSearch(X, Y, zSurface, zPlane, 1e-3);

    ZErrorArray(k) = abs(minZ - Z_fmin);
    distErrorArray(k) = sqrt((X_minz - X_fmin)^2 + (Y_minz - Y_fmin)^2);

end

figure()
plot(numPointsArray, ZErrorArray, '-o', 'DisplayName', 'Z Error'); hold on;
plot(numPointsArray, distErrorArray, '-s', 'DisplayName', 'Distance Error');
legend()
xlabel('numPoints')
ylabel('Error')
grid on


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