% packunpack.m
%
function p = packunpack(varargin)
% PACKUNPACK Pack or unpack variables into or out of a struct.
%   p = PACKUNPACK()    % packs all variables from caller into struct p
%   PACKUNPACK(p)       % unpacks fields of scalar struct p into caller

if nargin == 0
    % PACK: collect caller workspace variables into struct p
    names = evalin('caller', 'who');
    p = struct();
    for k = 1:numel(names)
        p.(names{k}) = evalin('caller', names{k});
    end
    return % End of function for the packing case
end

if nargin == 1
    inp = varargin{1};                 % avoid overwriting output name
    if ~isstruct(inp) || ~isscalar(inp)
        error('packunpack:input','Input must be a scalar struct.');
    end
    fn = fieldnames(inp);
    for k = 1:numel(fn)
        assignin('caller', fn{k}, inp.(fn{k}));
    end
    % no output for unpack case
   p =[];
   return  % End of function for the unpacking case
end

% Error is only seen if neither case above is observed.
error('packunpack:usage','Usage: p = packunpack() or packunpack(p)');


end