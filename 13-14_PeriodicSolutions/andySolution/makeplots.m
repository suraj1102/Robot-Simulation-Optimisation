function makeplots(uniquefixedpts, z0periodic,Tperiodic,p)
% Makes plots and animations.
% Variables in are
%  uniquefixedpts:  an array where each column is a fixed point
%  z0periodic:      an initial condition vector that yields a 
%                   periodic motion
%  Tperiodic:       The time it takes for one cycle of the 
%                   periodic solution
%  p                A struct containing all of the parameters defining
%                   this set of ODEs


packunpack(p); 
      simtime = Tperiodic;
      tspan  = [0, Tperiodic];      % duration of dynamic simulation
      tarray = linspace(0,Tperiodic,1000);
      speedup = 1;

  x0  = z0periodic(1); y0  = z0periodic(2);
  vx0 = z0periodic(3); vy0 = z0periodic(4);

ODEoptions = odeset('AbsTol',small,'RelTol',small);
[tarray zarray] = ode45(ODE,tarray,z0periodic,ODEoptions) ;
soln            = ode45(ODE, tspan, z0periodic, ODEoptions);

 x   = zarray(:,1);  y  = zarray(:,2);
 vx  = zarray(:,3); vy  = zarray(:,4);

 

%Plotting box size, find extreme point and put box outside that
xmin = min([x' uniquefixedpts(1,:) rA(1)-LA  rB(1)-LB ])-1;
ymin = min([y' uniquefixedpts(2,:) rA(2)-LA  rB(2)-LB ])-1;
xmax = max([x' uniquefixedpts(1,:) rA(1)+LA  rB(1)+LB ])+1;
ymax = max([y' uniquefixedpts(2,:) rA(2)+LA  rB(2)+LB ])+1;
vxmin= min(vx)-1;
vxmax= max(vx)+1;
vymin= min(vy)-1;
vymax= max(vy)+1;


t=tiledlayout(1,2);
ax1 = nexttile(t); hold(ax1,'on');
ax2 = nexttile(t); hold(ax2,'on');


plot(ax1, x(1)  ,   y(1)  ,  '*k' ,'MarkerSize', 10,'LineWidth',3)
axis(ax1,'equal')
axis(ax1,[xmin xmax ymin ymax]);

%Mark fixed points
plot(ax1,uniquefixedpts(1,:),uniquefixedpts(2,:), 'og',...
     'MarkerSize', 10, 'LineWidth', 2) % Location of equilibria
text(ax1,rA(1),rA(2),'A','FontSize',20)    % Location of anchor points
text(ax1,rB(1),rB(2),'B','FontSize',20)
plot(ax1,rA(1),rA(2),'+b','MarkerSize',10, 'LineWidth', 3)
plot(ax1,rB(1),rB(2),'+b','MarkerSize',10, 'LineWidth', 3)

title(ax1, 'Equilibrium and dynamics of a particle')
xlabel(ax1,{'x';'Green Circles are equilibrium points, A and B are anchors'})
ylabel(ax1,'y')
grid(ax1,true)

% Plot spring restlength circles
s = linspace(0, 2*pi, 100);
circleAx =  rA(1) + LA*cos(s);  circleAy = rA(2) + LA*sin(s);
circleBx =  rB(1) + LB*cos(s);  circleBy = rB(2) + LB*sin(s);
plot(ax1,circleAx,circleAy, circleBx,circleBy)



%Draw springs
springA    = plot(ax1,[rA(1) x0],[rA(2) y0], 'b');
springB    = plot(ax1,[rB(1) x0],[rB(2) y0], 'b');
mass2D       = plot(ax1,x0,y0,'.',MarkerSize=50);
trajectory2D = plot(ax1,x0,y0, 'LineWidth', 2);


%3D PLOT
plot3(ax2, x(1)  ,   vx(1)  , vy(1), '*k' ,'MarkerSize', 10)
view(ax2, 3)
axis(ax2,'vis3d')    % preserve aspect for 3D rotations
xlim(ax2,[xmin xmax]); ylim(ax2,[vxmin vxmax]); zlim(ax2,[vymin vymax]);

% turn on major grid lines on all three directions
ax2.XGrid = 'on';
ax2.YGrid = 'on';
ax2.ZGrid = 'on';

title(ax2, '3D trajectory:  x, vx, vy')
xlabel(ax2,'x')
ylabel(ax2,'vx')
zlabel(ax2,'vy')

mass3D       = plot3(ax2,x0,vx0,vy0,'.',MarkerSize=20);
trajectory3D = plot3(ax2,x0,vx0,vy0, 'LineWidth', 2);


tnow=0;
tic;

%ANIMATION LOOP FOR BOTH PLOTS
while tnow<simtime

tarray = linspace(0,tnow,1000);

zarray  = deval(soln,tarray);
xarray  = zarray(1,:);  yarray  = zarray(2,:);
vxarray = zarray(3,:);  vyarray = zarray(4,:);


springA.XData    = [rA(1),xarray(end)];  springA.YData   = [rA(2),yarray(end)];
springB.XData    = [rB(1),xarray(end)];  springB.YData   = [rB(2),yarray(end)];

mass2D.XData       = xarray(end);       mass2D.YData       = yarray(end);
trajectory2D.XData = xarray ;  trajectory2D.YData = yarray; 


mass3D.XData= xarray(end); mass3D.YData = vxarray(end); mass3D.ZData = vyarray(end);
trajectory3D.XData = xarray ;  trajectory3D.YData = vxarray; trajectory3D.ZData = vyarray;

drawnow;

tnow = toc*speedup;




end % of animation loop
hold off

end % of makeplots.m