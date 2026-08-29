%header.m
function headerfooter(startend)

%HEADER  and FOOTER FOR PRINTED OUTPUT

% Need to use strcmp (string compare) because of confustion between
% a text array and a string.  Using stopstart == 'start' gives an array of
% comparisons of each charactor.
if strcmp(startend,'start');  % start means start of execution
    tic
    fprintf('\n')
    disp('************************************************************')
    disp(['Start of exectution at ' ...
        datestr(now, 'HH:MM:SS.FFF ') '(hours:minutes:seconds)' ]) 
    disp('________')
    return
end

if strcmp(startend,'end')    % stop means end of execution
    fprintf('\n')
    disp('________')
    disp(['End   of exectution at ' ...
        datestr(now, 'HH:MM:SS.FFF ') '(hours:minutes:seconds)' ]) 
    %disp(['Elapsed time is               ' num2str(toc) ' seconds.'])
    disp('************************************************************') 
    disp(' ')
    return
end

error('correct usage:  headerfooter(''start'')  or headerfooter(''end'')');