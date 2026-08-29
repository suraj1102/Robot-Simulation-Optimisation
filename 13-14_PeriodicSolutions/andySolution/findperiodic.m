%findperiodic.m
function [z0periodic,Tperiodic] = findperiodic(p);

packunpack(p);
%Incudes: bounds on guesses to start search
%   ymin, ymax, vxmin, vxmax, vymin, vymax, Tmin, Tmax, searchtime

%Parameters setting up the array of initial guesses
tic; % start timer


%Set up options for FSOLVE.  This set seems to work well.
options = optimoptions('fsolve', 'FunctionTolerance', 1e-12,...
  'OptimalityTolerance',1e-8, 'MaxFunctionEvaluations', 1000,...
  'MaxIterations', 1000,'Disp','off',... % display off or iter
  'Algorithm','levenberg-marquardt'); 
Tperiodic =[];
z0periodic=[];


  i = 0;  % loop counter, starts at zero, counts number of guesses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LOOP, rootfinding, one guess and search per loop.
%end if periodic motion is found.

%To find a periodic motion we are seeking an initial condition z0 and
%a time T so that solving

    % zdot= f(z)
    % 
    % with initial condition z0 = z0periodic
    % until time             T  = Tperiodic
    % will yield the same    z(Tperiodic) = z0periodic.
    % After time T = Tperiodic, the position and velocity are the same
    % as they were at the start.  So, continuing in time we would get the
    % same solution over and over again.

tic; % start timer
while toc<searchtimefixedpts  % give up after defined time
        i = i+1;  %count times through loop

w(1)  = ymin  + (ymax -ymin )*rand(1); %Makes guesses for initial state
w(2)  = vxmin + (vxmax-vxmin)*rand(1);
w(3)  = vymin + (vymax-vymin)*rand(1);
w(4)  = Tmin  + (Tmax -Tmin )*rand(1);


F = @(w)  periodicerror(w,p);   %F is the thing that we want to be zero
   
% Use FSOLVE to find values for w for which there is a limit cycle
[finalw,fval,exitflag,output] =fsolve(F, w, options);
   Tout = finalw(4);
   if (norm(fval)<1e-4) && Tout>1e-1
      disp('A good z0 and T has been found found!')
      z0periodic = [0;finalw(1:3)']; 
      Tperiodic  = Tout;
      break  %stops search loop
      
     % exitflag< 1  Means "if bad root"
   

   else  
  disp(['Found bad root, period is ' num2str(Tout) '. norm(fval) is ' num2str(norm(fval))])
  z0periodic = [0;finalw(1:3)']; 
      Tperiodic  = Tout;
  
   end % end of if else
   end % END of Root finding loop


disp(['Number of initial guesses tried was   ' num2str(i)])



disp(['The z0 for fixed point has these [x; y; vx; vy] values: ' num2str(z0periodic')])
disp(['The period is ' num2str(Tperiodic)])


end