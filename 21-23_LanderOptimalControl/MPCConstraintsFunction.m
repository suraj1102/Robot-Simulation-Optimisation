function [c, ceq] = MPCConstraintsFunction(zmpc, p, initial_state)
    g = p.g;
    c = [];
    ceq = [];

    Np = p.Np;
    dtp = p.dtp;

    [x, z, vx, vz, ux, uz] = unpack_zmpc(zmpc, p);

    % Initial Condition
    ceq = [ceq; x(1) - initial_state(1) - 0.05];
    ceq = [ceq; z(1) - initial_state(2) - 0.05];
    ceq = [ceq; vx(1) - initial_state(3)];
    ceq = [ceq; vz(1) - initial_state(4)];

    % Initial Condition
    zfinal = p.zfinal;
    ceq = [ceq; x(1) - zfinal(1)];
    ceq = [ceq; z(1) - zfinal(2)];
    ceq = [ceq; vx(1) - zfinal(3)];
    ceq = [ceq; vz(1) - zfinal(4)];

    % Dynamics
    for i = 1:Np
        ceq = [ceq; x(i+1) - ( x(i) + dtp*vx(i) )];
        ceq = [ceq; z(i+1) - ( z(i) + dtp*vz(i) )];
        ceq = [ceq; vx(i+1) - ( vx(i) + dtp*ux(i) )];
        ceq = [ceq; vz(i+1) - ( vz(i) + dtp*( uz(i) - g ) )];
    end

    % Do not hit the ground - c(x) <= 0 i.e -z(i) <= 0
    for i = 1:length(z)
        c = [c; -z(i)];
    end

    % Control constraint - norm(control) <= umax
    umax = p.umax;
    for i = 1:length(ux)
        c = [c; norm([ux(i); uz(i)]) - umax ];
    end
end