%aREADME
%The top level function, the one you run, is called
%
%   MAIN    (main.m)

%Briefly
% Helper functions are
%   packunpack.m    is just for managing variables. It has no calculations.
%   headerfooter.m  is just for printout of start and stop time.
% 
% Key inputs are are:
%   p               A list of all parameters
%   ODE & ODEz      the 'handles' for the right hand side file 

% Key outpus are:
%   uniquefixedpts  An array.  Each column is a 4 element fixed point
%   z0periodic      Column vector. Initial condition for a periodic solution
%   Tperiodic       The period of the periodic solution

% THE MAIN FUNCTIONS IN THE FOLDER
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% 
% MAIN is the function to run. main.m calls
%   HEADERFOOTER  which announces the start and end of execution;
%   SETPARAMETERS which sets all constants and handles and 
%                 puts them in struct p; 
%                 It also gives ranges for the initial guesses for the
%                 search for periodic solutions;
%                 It also gives the user's 
%      MYRHS(z,p) the function handles ODE and ODEz;
%                 it calls 
%      PACKUNPACK which, say, puts c,d  into p.c and p.d
%                 or the inverse, unpackping p into c and d;
%   FINDFIXEDPOINTS finds  the fixed points of MYRHS using FSOLVE;
%   FINDPERIODIC uses a random starting guess to give to FSOLVE to
%                find one periodic solution.  The method is called 'shooting'.
%       findperiodic.m  uses 
%       PERIODICERROR which calculates the 'error', the difference 
%       betseen the IC and the final state (this is how bad the guess was).
%       A periodic solution is when that error is zero.
%   MAKEPLOTS uses the results of the calculations above so as to plot 
%       fixed points and to animate a periodic solution.


%   Each time you run MAIN, it finds a new periodic motion for the system 
%   using a different random guess.
 
%   The parameters ymin, ymax, etc set the range from which the random 
%   initial guesses are selected.

