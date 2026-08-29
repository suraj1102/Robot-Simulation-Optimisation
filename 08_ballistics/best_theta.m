clc; clear; close all;

p.m = 1;
p.c = 1;
p.g = 1;

t0 = 0; tf = 200;
tspan = [t0 tf];

v_list = linspace(0, 5, 100);
theta_star = zeros(size(v_list));
range_vals = zeros(size(v_list));

for k = 1:length(v_list)

    v0_mag = v_list(k);
    theta_vals = linspace(1,89,150);
    ranges = zeros(size(theta_vals));

    for i = 1:length(theta_vals)

        theta = deg2rad(theta_vals(i));
        r0 = [0;0];
        v0 = [v0_mag*cos(theta); v0_mag*sin(theta)];
        z0 = [r0; v0];

        RHS = @(t,z) myRHS(t,z,p);
        event = @myEvent;
        opts = odeset('Events', event);

        sol = ode45(RHS, tspan, z0, opts);

        % range = final x value
        ranges(i) = sol.y(1,end);
    end

    [~,idx] = max(ranges);
    theta_star(k) = theta_vals(idx);
    range_vals(k) = max(ranges);
end

figure
plot(v_list, theta_star, 'o-','LineWidth',2)
title("\theta vs v_0 for maximizing range")
xlabel('v_0')
ylabel('\theta^* (deg)')
grid on

figure
plot(v_list, range_vals, '-','LineWidth',2)
hold on
d_dv_range = gradient(range_vals, v_list);
plot(v_list, d_dv_range)
title("range vs v_0 for maximizing range")
legend("range", "grad(range)")
xlabel('v_0')
ylabel('range (m)')
grid on