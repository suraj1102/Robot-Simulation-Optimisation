% See trajectory and animation for a 2D spring mass system
clear; clc; close;

% Euler Method to Solve an ODE
t0 = 0;
tf = 10;
timespan = [t0 tf];

% System Constants
p.mass = 0.1; % Mass of bob (kg)
p.g = 10; % m/s^2
p.k = 5; % Spring coef (N/m)
p.l0 = 0.1; % Free Length of Spring (m)

% Initial Conditions
x = 3;
vx = 0.03;
y = 1;
vy = 0.5;
z_0 = [x; vx; y; vy];

% Solver params 
n = 10e2 + 1;

% RHS Handler function
RHS = @(t,z)  myRHS(t,z,p);

% Solver
[tarray, zarray] = ODEEuler(RHS, timespan, z_0, n);

xArray = zarray(:,1);
vxArray = zarray(:,2);
yArray = zarray(:,3);
vyArray = zarray(:,4);


% Animation
figure(1)
hold on
axis equal
grid on
xlabel('x')
ylabel('y')
title('Spring Mass Animation')

xmin = min(xArray); xmax = max(xArray);
ymin = min(yArray); ymax = max(yArray);


% for i = 2:length(xArray)
%     cla
%     % Plot trajectory so far
%     plot(xArray(1:i), yArray(1:i), 'b-')
%     hold on
%     % Plot  current point
%     plot(xArray(i), yArray(i), 'ro')
%     % Set axis limits
% 
%     xlim([xmin xmax] + [-1 1])
%     ylim([ymin ymax] + [-1 1])
% 
%     pause(0.001)
% end


% Plotting Full Trajectory
figure(2)
plot(xArray, yArray)
title('Spring Mass Trajectory')
xlabel('x');
ylabel('y');
axis equal
shg



function  zdot = myRHS(t,z,p)
  m = p.mass;
  g = p.g;
  k = p.k;
  l0 = p.l0;
  
  x = z(1);
  vx = z(2);
  y = z(3);
  vy = z(4);

  l = sqrt(x^2 + y^2);
  % If l is 0, i.e. mass at origin, prevent errors.
  if l < 1e-8
    l = 1e-8;
  end
  T = k * (l - l0);
  
  % ODEs
  x_dot = vx;
  vx_dot = -T  * x / (m*l);
  y_dot = vy;
  vy_dot = -g + T * y / (m*l);
    
  zdot = [x_dot; vx_dot; y_dot; vy_dot];
end


function  [tarray, zarray] = ODEEuler(funct, timespan, z0, n)
    t0 = timespan(1); 
    tf = timespan(2);
    neqns = length(z0);
    
    h = (tf - t0) / (n-1);
    
    tarray = linspace(t0, tf, n);
    zarray = zeros(n,neqns);
    zarray(1,:) = z0'; % z0 is col vec, make it a row vec
    znew = z0; % znew is a col vec
    
    
    for k = 1:n-1
        zold = znew;
        t = tarray(k);
        
        % Euler Method
        zdot = funct(t, zold);
        znew = zold + zdot * h;
        
        zarray(k+1,:) = znew'; % Convert back to row vec
    end
end