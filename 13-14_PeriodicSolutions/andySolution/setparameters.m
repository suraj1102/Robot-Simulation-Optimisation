%setparameters.m
function p = setparameters()
%Set all parameters
rA = [-3   3]';   % Location of anchor A
rB = [ 3  -3]';   % Location of anchor B
kA = 1;   LA = 5;  cA = 0;  % Constants for spring/damper A
kB = 1;   LB = 5;  cB = 0;  % Constants for spring/damper B
c  = 0;   m  = 1;   g = 10; % More system contants.

%parameters above are needed to define function handles ODE and ODEz
ptemp = packunpack();

ODE  = @(t,z)  myrhs(z,ptemp);  % This for ODE45 solutions.  
ODEz = @(z)    myrhs(z,ptemp);  % This is for fixed points
clear ptemp  % so  that p does not include ptemp

%More things are added to p, below.

small = 1e-6;   % tolerance for ODE45

%Set range of values for initial guesses
xmin  = -10;  xmax = 10;  % used for fixed pts, for periodic solns x=0
ymin  = 3;  ymax = 7; 
vxmin = 5; vxmax = 7; 
vymin = 4;  vymax = 15;
Tmin  = 15; Tmax  = 20;

searchtimefixedpts =  60;   % How long to look for fixed points, in seconds

nfixedptguesses = 10;  % That's for x and y, so square it  for actual #

%PACK _all_ parameters defined above into  p, including function handles 
p = packunpack();   % Unpacking works like this:
%    packunpack(p); % This puts all elements of p in workspace

end