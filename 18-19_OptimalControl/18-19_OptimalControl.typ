#import "lib.typ": *

#show: university-assignment.with(
  title: "Optimal Control",
  subtitle: "P. 18,19 - Robot Optimization",
  author: "Suraj Dayma",
)

= Problem 18

Solve the optimal control problem $dot.double(x) = u$ subject to $x(0) = 0, x(1) = 1, v(0)=v(1)=0$

My $z = [x_0, x_1, ..., x_N, v_0, v_1, ..., v_N, u_0, u_1, ..., u_(N-1)]$

So number of x equations is N+1, number of v equations is N+1, number of u equations is N.

== N = 4

#image("imgs/N=4Sol.png")

== N = 100

#image("imgs/N=100Sol.png")


== Code - Using nonlcon

```matlab
clear; close all; clc;

N = 100;
t0 = 0;
tf = 1;
h = (tf-t0) / (N + 1);


z_guess = zeros(2*(N+1) + N, 1);
cost_func = @(z) obj_fun(z, N, h);
nonlcon = @(z) const_fun(z, N, h);

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
[z_opt, fval] = fmincon(cost_func, z_guess, ...
                        [], [], [], [], [], [], ...
                        nonlcon, ...
                        options);

% Unpack solution
x1 = z_opt(1 : N+1);
x2 = z_opt(N+2 : 2*N+2);
u  = z_opt(2*N+3 : end);
t = linspace(t0, tf, N+1);

figure() 
hold on;
plot(t, x1, '--.', DisplayName='Position');
plot(t, x2, '--.', DisplayName='Velocity');
plot(t(1: end-1), u, '--.', DisplayName='Control');
legend();
grid on;


function J = obj_fun(z, N, h)
    u = z(2*N+3 : end);
    J = sum(u(1:N).^2) * h; 
end

```
```matlab
function [c, ceq] = const_fun(z, N, h)
    x1 = z(1 : N+1);
    x2 = z(N+2 : 2*N+2);
    u  = z(2*N+3 : end);
    
    ceq = [];
    
    % Boundary Constraints
    ceq = [ceq; x1(1) - 0];
    ceq = [ceq; x2(1) - 0];
    ceq = [ceq; x1(N+1) - 1];
    ceq = [ceq; x2(N+1) - 0];
    
    % Dynamics
    for i = 1:N
        ceq = [ceq; x1(i+1) - (x1(i) + h * x2(i))];
        ceq = [ceq; x2(i+1) - (x2(i) + h * u(i))];
    end
    
    c = []; % No inequality constraints
end
```


= Problem 19 - Trapezoidal Discretization

Solve above problem using trap. disc. and compare accuracy with Euler solution. 

