function  uniquefixedpts  = findfixedpoints(p)
% This function finds fixed points of the given ode, zdot = f(z), where f
% defines the ODE.
% Fixed points z* of f are values of z for which a f(z*) = 0.
% So the heart of this function is that rootfinding.
% Rootfinding is hard so we take lots of initial guesses.
% Then we only keep converged results.
% Then we throw away duplicates.

packunpack(p); % This puts all variables from SETPARAMETERS into
               % this function



%SET UP ROOT FINDING
% initialize arrays for storing the supposed roots from each guess
fixedptarray  = zeros(4,nfixedptguesses^2);  % Stores all good roots found by guesses
i = 0;  % loop counter, starts at zero, counts up to number of
        % converged solutions.

%Set up options for FSOLVE.  This set seems to work well.
options = optimoptions('fsolve', 'FunctionTolerance', 1e-12,...
  'OptimalityTolerance',1e-8, 'MaxFunctionEvaluations', 10000,...
  'MaxIterations', 1000,'Disp','off',... % display off or iter
  'Algorithm','levenberg-marquardt'); 
  


%%%%%%%%%%%%%%%%%%%%%%
%STATICS SOLUTION, Find lots of roots
% Note if mass at C is at A or B, that gives divide by zero
for xguess = linspace(xmin,xmax,nfixedptguesses)     % Try all these x guesses
    for yguess = linspace(ymin,ymax,nfixedptguesses) % For each x guess try these y guesses
        
   
% Use FSOLVE to find x,y pairs that result in zdot = [0 0 0 0]' 
% All initial guesses use [vx0, vyo] = [0,0]
zguess=[xguess;yguess;0;0];  % starter for fsolve
[fixedpt,fval,exitflag] = fsolve(ODEz,zguess, options); 
  if norm(fval)>1e-4  %This is bad.
     %This should be zero if FSOLVE did its job correctly.
     %Don't save, don't do anything. Try again.  
  else         % This is good. :).
     i = i+1;  %c ount successful times through loop
     fixedptarray(:,i) = fixedpt;  %Store each good root in this array of roots
  end %end if     else  
  
  end % end yguess loop
end   % end xguess loop


fixedptarray    = round(fixedptarray(:,1:i),4);  % round the root values so duplicates can be found

%This is the output of this funtion:
uniquefixedpts  = unique(fixedptarray','rows')'; % Only save unique fixed points (which are rows of fixedptarray)

nunique         = length(uniquefixedpts(1,:));   %  Number of unique fixed points (now that duplicates are gone)

%Output to the command window:
disp(['Number of initial fixed point guesses tried was   ' num2str(nfixedptguesses^2)])
disp(['The ' num2str(i) ' converged guesses have these ' num2str(nunique) ' unique equilibrium points'])
disp(' (Each column, [x; y; vx; vy],  is one root):')
disp(uniquefixedpts) 

end


