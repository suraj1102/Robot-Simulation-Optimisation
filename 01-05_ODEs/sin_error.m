clear; clc; close;
% How accurate is the numerical sin function.

format long

h = 10^-4;
x = 1;

% % Testing
% ddx_sinx = sin(x + h) - sin(x);
% ddx_sinx = ddx_sinx / h
% 
% cos_x = cos(x)
% error = ddx_sinx - cos_x


% Find best h
h_vals = 10.^ (-1:-1:-12);
error_vals = zeros(length(h_vals), 1);
for i = 1:length(h_vals)
    h = h_vals(i);
    ddx_sinx = sin(x + h) - sin(x);
    ddx_sinx = ddx_sinx / h;

    cos_x = cos(x);
    error = abs(ddx_sinx - cos_x);
    error_vals(i) = error;
end

% Plot Results
loglog(h_vals, error_vals, '-o')
xlabel("h")
ylabel("Error")
title("Estimation of sin(x)")
grid on