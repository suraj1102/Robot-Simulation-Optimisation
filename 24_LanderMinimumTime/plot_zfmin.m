function plot_zfmin(zfmin, problem)
    N = problem.numPoints;

    [x, z, vx, vz, ux, uz, T] = unpack_zfmin(zfmin, problem);
    
    tarray = linspace(0, T, N + 1);
    
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
    plot(tarray, ux', '- .'); grid on;
    title("ux"); xlabel("t");
    
    nexttile;
    plot(tarray, uz', '- .'); grid on;
    title("uz"); xlabel("t");
    
    sgtitle(sprintf("State and Control Trajectories (Optimal Time T = %.3f s)", T));
    
    figure(); hold on;
    plot(x, z, '- .');
    grid on;
    xlabel("x"); ylabel("z"); title("Phase Plot");

    figure();
    plot(tarray, sqrt(ux.^2 + uz.^2), '- .'); hold on;
    plot([0 T], [problem.umax problem.umax], 'r--', 'LineWidth', 1.5);
    grid on;
    title("Thrust Magnitude vs Time");
    legend('Thrust', 'Umax limit');
end