function [c, ceq] = constraintsFunction(zfmin, problem)
    [g, zinit, zfinal, numPoints, tspan] = unpack_p(problem);
    c = [];
    ceq = [];

    N = numPoints;
    dt = (tspan(2) - tspan(1)) / N;

    [x, z, vx, vz, ux, uz] = unpack_zfmin(zfmin, problem);

    % Boundary Conditions
    ceq = [ceq; x(1) - zinit(1)];
    ceq = [ceq; z(1) - zinit(2)];
    ceq = [ceq; vx(1) - zinit(3)];
    ceq = [ceq; vz(1) - zinit(4)];

    ceq = [ceq; x(end) - zfinal(1)];
    ceq = [ceq; z(end) - zfinal(2)];
    ceq = [ceq; vx(end) - zfinal(3)];
    ceq = [ceq; vz(end) - zfinal(4)];

    % Dynamics
    for i = 1:N
        ceq = [ceq; x(i+1) - ( x(i) + dt*vx(i) )];
        ceq = [ceq; z(i+1) - ( z(i) + dt*vz(i) )];
        ceq = [ceq; vx(i+1) - ( vx(i) + dt*ux(i) )];
        ceq = [ceq; vz(i+1) - ( vz(i) + dt*( uz(i) - g ) )];
    end

    % Do not hit the ground - c(x) <= 0 i.e -z(i) <= 0
    for i = 1:length(z)
        c = [c; -z(i)];
    end

    % Control constraint - norm(control) <= umax
    umax = problem.umax;
    for i = 1:length(ux)
        c = [c; norm([ux(i); uz(i)]) - umax ];
    end
end