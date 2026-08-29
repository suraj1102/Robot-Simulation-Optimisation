%finderror.m
function error = periodicerror(w,p);
% Goal,  Find w so that this function give out [0;0;0;0]
% This function is called by findperiodic.m.
% This calculate the quantity 'error' that the optimizer is tryint to find.


packunpack(p);

x0  = 0;      % 'Poincare' section is x0 = 0 plane.
y0  = w(1);   % Four variables in (w(1),w(2), w(3). & w(4).
vx0 = w(2);
vy0 = w(3);
T   = w(4); 


tspan = [0 T];
options = odeset('AbsTol',small, 'RelTol',small);

z0=[x0;y0;vx0;vy0];

[tarray zarray]= ode45(ODE,tspan,z0,options);

%And 4 variables out: The difference between z0 and z(end).
error = zarray(end,:)' - z0; %Soln of ODE at time T should match IC.

% If error  is all zeros, we have found a w corresponding to a 
% periodic motion.

end