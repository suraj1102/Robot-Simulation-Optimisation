% main
% FIXED POINT AND PERIODIC MOTION FUNCTION
% GIVEN AN ODE, THIS CODE FINDS SPECIAL SOLUTIONS:
%   FIXED POINTS and a PERIODIC MOTION. 
%       -Andy Ruina,    March 24-27, 2026

% THIS EXAMPLE: The example here is A MASS HUNG FROM TWO SPRINGS, 
% each with a paralel dashpot (set to zero for periodic motions) 
% and also acted on by viscous friction (set to zero for periodic 
% motions) and gravity. 

%Read the aREADME file for more general information.



clear all, clf, clc    %clf keeps figure window in same place at same size.
headerfooter('start')  %Prints things about start time in output

%SET ALL PARAMETERS
p = setparameters();  %masses, lengths, constants, function handles, etc

%FIND FIXED POINTS
uniquefixedpts = findfixedpoints(p);

%FIND PERIODIC  SOLUTIONS
[z0periodic,Tperiodic] = findperiodic(p);  % Note, p includes the ODE

%PLOTS AND ANIMATIONS
makeplots(uniquefixedpts, z0periodic,Tperiodic,p);

%TIMER
headerfooter('end')    % Prints things about end time.

%THAT'S ALL FOLKS.