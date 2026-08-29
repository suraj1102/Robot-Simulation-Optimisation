clear; clc; close all;

t0 = 0; tf = 1;
N = 10;
h = (tf-t0)/N;

% Boundary Conditions
x0 = 0; xf = 0;

%% Euler Discretization
% N intervals => N+1 points
tArray = linspace(t0, tf, N+1);

dimA = 2*(N+1);        % [x0..xN, v0..vN]
A = zeros(dimA, dimA);
b = zeros(dimA, 1);

xIdx = 1:(N+1);
vIdx = (N+2):dimA;

% x0 BC
A(1, xIdx(1)) = 1;
b(1) = x0;

% x(i) - x(i-1) - h*v(i-1) = 0 | i = 1..N
for i = 1:N
    row = i + 1;
    A(row, xIdx(i+1)) = 1;
    A(row, xIdx(i))   = -1;
    A(row, vIdx(i))   = -h;
end

% xf BC
% This row corresponds to the v0 row in the states vector, as v0 is a free
% variable, we only populate the column being multiplied with xN and use
% this row as the xf BC.
A(N+2, xIdx(end)) = 1;
b(N+2) = xf;

% v(i) - v(i-1) = -h | i = 1..N
for i = 1:N
    row = N + 2 + i;
    A(row, vIdx(i+1)) = 1;
    A(row, vIdx(i))   = -1;
    b(row) = -h;
end

z = A \ b;

x = z(xIdx);
v = z(vIdx);

%% Results
disp(["V0: " v(1)])
