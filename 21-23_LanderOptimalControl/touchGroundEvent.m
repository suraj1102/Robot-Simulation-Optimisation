function [value,isterminal,direction] = touchGroundEvent(t, zall)
    [x, z, vx, vz] = unpack_z(zall);
    value = z; % The thing we want equal to 0 
    isterminal = 1; % Halt integration 
    direction = -1; % 0, 1, -1: -1 meaning z is decreasing as it goes to 0
end