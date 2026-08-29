clear; close all; clc;

N = 41;
t0 = 0;
tf = 1;
h = (tf-t0) / (N-1);


z_guess = zeros(3*(N), 1);
cost_func = @(z) obj_fun(z, N, h);
nonlcon = @(z) const_fun_trap(z, N, h);

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
[z_opt, fval] = fmincon(cost_func, z_guess, ...
                        [], [], [], [], [], [], ...
                        nonlcon, ...
                        options);

% Unpack solution
x1 = z_opt(1 : N);
x2 = z_opt(N+1 : 2*N);
u = z_opt(2*N+1 : end);
t = linspace(t0, tf, N);

figure() 
hold on;
plot(t, x1, '-o', DisplayName='Position');
plot(t, x2, '-o', DisplayName='Velocity');
plot(t, u, '-o', DisplayName='Control');
legend();
grid on;


Ns = [20, 40, 80, 160];
costs = zeros(size(Ns));
t0 = 0;
tf = 1;

fprintf('N \t\t Cost J \t\t Error |J_N - J_2N| \t Ratio\n');
fprintf('------------------------------------------------------------\n');

for k = 1:length(Ns)
    N = Ns(k);
    h = (tf-t0) / (N - 1);
    
    % Setup optimization
    cost_func = @(z) obj_fun(z, N, h);
    nonlcon = @(z) const_fun_trap(z, N, h);
    
    % 'sqp' is usually faster and more robust for these constraints
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp');
    z_guess = zeros(3*(N), 1);
    [~, costs(k)] = fmincon(cost_func, z_guess, [], [], [], [], [], [], nonlcon, options);
    
    % Calculate and print results
    if k > 1
        err = abs(costs(k) - costs(k-1));
        if k > 2
            prev_err = abs(costs(k-1) - costs(k-2));
            ratio = prev_err / err;
            fprintf('%d \t %.8f \t %.8e \t %.2f\n', N, costs(k), err, ratio);
        else
            fprintf('%d \t %.8f \t %.8e \t ---\n', N, costs(k), err);
        end
    else
        fprintf('%d \t %.8f \t --- \t\t\t ---\n', N, costs(k));
    end
end


function J = obj_fun(z, N, h)
    x1 = z(1 : N);
    x2 = z(N+1 : 2*N);
    u = z(2*N+1 : end);

    J = sum(u(2:end-1).^2) + ( u(1)^2 + u(end)^2 ) / 2;
    J = J * h;
end


function [c, ceq] = const_fun(z, N, h)
    x1 = z(1 : N+1);
    x2 = z(N+2 : 2*N+2);
    u  = z(2*N+3 : end);
    
    ceq = [];
    
    % Boundary Constraints
    ceq = [ceq; x1(1) - 0];
    ceq = [ceq; x2(1) - 0];
    ceq = [ceq; x1(N) - 1];
    ceq = [ceq; x2(N) - 0];
    
    % Dynamics
    for i = 1:N
        ceq = [ceq; x1(i+1) - (x1(i) + h * x2(i))];
        ceq = [ceq; x2(i+1) - (x2(i) + h * u(i))];
    end
    
    c = []; % No inequality constraints
end

function [c, ceq] = const_fun_trap(z, N, h)
    x1 = z(1 : N);
    x2 = z(N+1 : 2*N);
    u = z(2*N+1 : end);
    
    ceq = [];
    
    % Boundary Constraints
    ceq = [ceq; x1(1) - 0];
    ceq = [ceq; x2(1) - 0];
    ceq = [ceq; x1(N) - 1];
    ceq = [ceq; x2(N) - 0];
    
    % Dynamics
    for i = 1:N-1
        ceq = [ceq; x1(i+1) - (x1(i) + h/2 * (x2(i) + x2(i+1)) )];
        ceq = [ceq; x2(i+1) - (x2(i) + h/2 * ( u(i) +  u(i+1)) )];
    end
    
    c = []; % No inequality constraints
end