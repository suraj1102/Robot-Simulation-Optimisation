function [x, z, vx, vz, ux, uz] = unpack_zmpc(zmpc, problem)
    % Uses Np instead of N
    Np = problem.Np;

    % Extact Stae Variables
    x  = zmpc(1         : Np+1);
    z  = zmpc((Np+1)+1   : 2*(Np+1));
    vx = zmpc(2*(Np+1)+1 : 3*(Np+1));
    vz = zmpc(3*(Np+1)+1 : 4*(Np+1));
    
    % Extract Control Variables
    ux = zmpc(4*(Np+1)+1   : 4*(Np+1) + Np);
    uz = zmpc(4*(Np+1)+Np+1 : 4*(Np+1) + 2*Np);

    % ux = zmpc(4*(Np+1)+1 : 5*(Np+1));
    % uz = zmpc(5*(Np+1)+1 : 6*(Np+1));
end