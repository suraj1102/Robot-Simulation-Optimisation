function [x, z, vx, vz, ux, uz, T] = unpack_zfmin(zfmin, problem)
    N = problem.numPoints;

    % Extact Stae Variables
    x  = zfmin(1         : N+1);
    z  = zfmin((N+1)+1   : 2*(N+1));
    vx = zfmin(2*(N+1)+1 : 3*(N+1));
    vz = zfmin(3*(N+1)+1 : 4*(N+1));
    
    % Extract Control Variables
    ux = zfmin(4*(N+1)+1 : 5*(N+1));
    uz = zfmin(5*(N+1)+1 : 6*(N+1));

    T  = zfmin(end);
end