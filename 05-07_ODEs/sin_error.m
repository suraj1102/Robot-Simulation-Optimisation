clear; clc; close;
% How accurate is the numerical sin function.

format long
x = 1;

% Find best h
h_vals = 10.^ (-1:-1:-12);
right_diff_error_vals = zeros(length(h_vals), 1);
central_diff_error_vals = zeros(length(h_vals), 1);

for i = 1:length(h_vals)
    h = h_vals(i);
    
    % Right Difference Method
    ddx_sinx = sin(x + h) - sin(x);
    ddx_sinx = ddx_sinx / h;

    cos_x = cos(x);
    error = abs(ddx_sinx - cos_x);
    right_diff_error_vals(i) = error;

    % Central Difference Method
    ddx_sinx = sin(x + h) - sin(x - h);
    ddx_sinx = ddx_sinx/(2*h);
    error = abs(ddx_sinx - cos_x);
    central_diff_error_vals(i) = error;
end

% Plot Results
loglog(h_vals, right_diff_error_vals, '-o')
hold on
loglog(h_vals, central_diff_error_vals, '-o')
xlabel("h")
ylabel("Error")
legend("Right Diff.", "Central Diff.")
title("Estimation of sin(x)")
grid on