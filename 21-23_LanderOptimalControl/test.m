clc
clear
close all

T = 1;

% mesh sizes
Nvec = [10 20 40 80 160];

err = zeros(length(Nvec),1);
hvec = zeros(length(Nvec),1);

for m = 1:length(Nvec)

    N = Nvec(m);

    h = T / N;

    hvec(m) = h;

    nz = 3*(N+1);

    % initial guess
    z0 = zeros(nz,1);

    x_guess = linspace(0,1,N+1);

    z0(1:N+1) = x_guess;

    lb = -inf(nz,1);
    ub = inf(nz,1);

    options = optimoptions('fmincon', ...
        'Algorithm','sqp', ...
        'Display','none', ...
        'MaxFunctionEvaluations',1e6);

    z = fmincon(@(z)objective(z,N,h), ...
                z0, ...
                [],[],[],[], ...
                lb,ub, ...
                @(z)constraints(z,N,h), ...
                options);
x = z(1:N+1);
v = z(N+2:2*(N+1));
u = z(2*(N+1)+1:end);
    t = linspace(0,T,N+1);

% plots
figure

subplot(3,1,1)
plot(t,x,'LineWidth',2)
xlabel('t')
ylabel('x')

subplot(3,1,2)
plot(t,v,'LineWidth',2)
xlabel('t')
ylabel('v')

subplot(3,1,3)
plot(t,u,'LineWidth',2)
xlabel('t')
ylabel('u')

    % numerical solution
    x_num = z(1:N+1);

    % exact solution
    t = linspace(0,T,N+1);

    x_exact = 3*t.^2 - 2*t.^3;

    err(m) = max(abs(x_num(:) - x_exact(:)));

end

% error ratios
ratio = zeros(length(Nvec)-1,1);

for k = 1:length(ratio)

    ratio(k) = err(k) / err(k+1);

end

% display table
fprintf('\n');
fprintf('   N           h              error            ratio\n');
fprintf('--------------------------------------------------------\n');

for k = 1:length(Nvec)

    if k == 1
        fprintf('%5d   %12.5e   %12.5e        -\n', ...
            Nvec(k), hvec(k), err(k));
    else
        fprintf('%5d   %12.5e   %12.5e    %8.4f\n', ...
            Nvec(k), hvec(k), err(k), ratio(k-1));
    end

end

% loglog plot
figure
loglog(hvec,err,'o-','LineWidth',2)

xlabel('h')
ylabel('max error')

grid on

% objective
function J = objective(z,N,h)

u = z(2*(N+1)+1:end);

J = 0;

for k = 1:N

    J = J + (h/2) * (u(k)^2 + u(k+1)^2);

end

end

% constraints
function [c,ceq] = constraints(z,N,h)

x = z(1:N+1);
v = z(N+2:2*(N+1));
u = z(2*(N+1)+1:end);

ceq = [];

for k = 1:N

    % xdot = v
    ceq = [ceq;
        x(k+1) - x(k) ...
        - (h/2)*(v(k) + v(k+1))];

    % vdot = u
    ceq = [ceq;
        v(k+1) - v(k) ...
        - (h/2)*(u(k) + u(k+1))];

end

% boundary conditions
ceq = [ceq;
    x(1);
    v(1);
    x(end) - 1;
    v(end)];

c = [];

end