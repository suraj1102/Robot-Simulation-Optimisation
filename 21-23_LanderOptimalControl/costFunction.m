function cost = costFunction(zfmin, problem)
    R = problem.R;
    N = problem.numPoints;
    [x, z, vx, vz, ux, uz] = unpack_zfmin(zfmin, problem);


    cost = 0;
    for i = 1:length(ux)
        u = [ux(i); uz(i)];
        cost = cost + u' * R * u;
    end

    dt = (problem.tf - problem.t0) / N;
    cost = cost * dt;
end
