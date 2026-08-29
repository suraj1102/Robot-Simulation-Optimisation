function plot_zfmin(zfmin, problem)
    N = problem.numPoints;
    tspan = problem.tspan;

    [x, z, vx, vz, ux, uz] = unpack_zfmin(zfmin, problem);
    tarray = linspace(tspan(1), tspan(2), N + 1);
    
    figure();
    tiledlayout(3, 2);
    
    nexttile;
    plot(tarray, x', '- .'); grid on;
    title("x"); xlabel("t");
    
    nexttile;
    plot(tarray, z', '- .'); grid on;
    title("z"); xlabel("t");
    
    nexttile;
    plot(tarray, vx', '- .'); grid on;
    title("vx"); xlabel("t");
    
    nexttile;
    plot(tarray, vz', '- .'); grid on;
    title("vz"); xlabel("t");
    
    nexttile;
    plot(tarray(1: end-1), ux', '- .'); grid on;
    title("ux"); xlabel("t");
    
    nexttile;
    plot(tarray(1: end-1), uz', '- .'); grid on;
    title("uz"); xlabel("t");
    
    sgtitle("State and Control Trajectories");
    
    
    figure(); hold on;
    plot(x, z, '- .');
    grid on;
    xlabel("x"); ylabel("z"); title("Phase Plot");

    figure();
    plot(tarray(1: end-1), sqrt(ux.^2 + uz.^2), '- .')
    grid on;
    title("Thrust Magnitude vs Time");

end