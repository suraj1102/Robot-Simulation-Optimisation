#import "lib.typ": *

#show: university-assignment.with(
  title: "Mystery Matrix",
  subtitle: "P.20 Robot Motion, Simulation, Optimization",
  author: "Suraj Dayma",
)

= Solution 

```matlab
clear; clc; close all;


m = 3;
A = myDetective(m)

function myA = myDetective(m)
    myA = [];
    for i = 1:m
        v = zeros(m,1);
        v(i) = 1;
        u = andymatrix(v);
        myA = [myA, u];
    end
end


function u = andymatrix(v)
    % A is a nxm. You are given m
    A = [
            1, 2, 3;
            4, 5, 6;
            7, 8, 9;
        ];
    
    u = A * v;
end
```

== When could we use this method in this course?

To find jacobians.

== Stable Periodic Motion

```matlab
function M = findJacobian(x_star, T, m)
    eps = 1e-8; % A tiny perturbation
    A = zeros(m, m);
    
    for i = 1:m
        v_perturb = zeros(m, 1);
        v_perturb(i) = eps;

        x0 = x_star + v_perturb;
        [~, x_final] = ode45(@myRHS, [0 T], x0);
        
        u = (x_final(end, :)' - x_star) / eps;
        
        J(:, i) = u;
    end
end
```