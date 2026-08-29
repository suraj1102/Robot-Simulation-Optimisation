function openLoopExec(zfmin_opt, p)
    [g, zinit, zfinal, numPoints, tspan] = unpack_p(p);
    [x_opt, z_opt, vx_opt, vz_opt, ux_opt, uz_opt] = unpack_zfmin(zfmin_opt, p);
    N = p.numPoints;
    
    alpha = [0.7, 0.9];
    
    % Populate Control
    ux = alpha(1) .* ux_opt;
    uz = alpha(2) .* uz_opt;
    
    % Simulate using rhs and Euler Integration
    dt = (tspan(2) - tspan(1)) / N;
    ztraj = zeros(4, N+1);
    ztraj(:,1) = zinit;
    for k = 1:N
        zk = ztraj(:,k);
        uk = [ux(k); uz(k)];
        zkdot = rhs(0, zk, uk, p);
        ztraj(:,k+1) = zk + dt * zkdot;
    end
    
    x  = ztraj(1,:);
    z  = ztraj(2,:);
    vx = ztraj(3,:);
    vz = ztraj(4,:);
    
    tarray = linspace(tspan(1), tspan(2), N + 1);
    
    
    figure();
    tiledlayout(3, 2);
    
    nexttile;
    hold on;
    plot(tarray, x_opt', '- .');
    plot(tarray, x, '--.');
    grid on;
    title("x"); xlabel("t");
    legend('Optimal', 'Actual');
    
    nexttile;
    hold on;
    plot(tarray, z_opt', '- .');
    plot(tarray, z, '--.');
    grid on;
    title("z"); xlabel("t");
    legend('Optimal', 'Actual');
    
    nexttile;
    hold on;
    plot(tarray, vx_opt', '- .');
    plot(tarray, vx, '--.');
    grid on;
    title("vx"); xlabel("t");
    legend('Optimal', 'Actual');
    
    nexttile;
    hold on;
    plot(tarray, vz_opt', '- .');
    plot(tarray, vz, '--.');
    grid on;
    title("vz"); xlabel("t");
    legend('Optimal', 'Actual');
    
    nexttile;
    hold on;
    plot(tarray(1:end-1), ux_opt', '- .');
    plot(tarray(1:end-1), ux, '--.');
    grid on;
    title("ux"); xlabel("t");
    legend('Optimal', 'Actual');
    
    nexttile;
    hold on;
    plot(tarray(1:end-1), uz_opt', '- .');
    plot(tarray(1:end-1), uz, '--.');
    grid on;
    title("uz"); xlabel("t");
    legend('Optimal', 'Actual');
    
    sgtitle("State and Control Trajectories");
    
    
    figure();
    hold on;
    plot(x_opt, z_opt, '- .');
    plot(x, z, '--.');
    grid on;
    xlabel("x");
    ylabel("z");
    title("Phase Plot");
    legend('Optimal', 'Actual');
    
    
    figure();
    tiledlayout(3, 2);
    
    nexttile;
    hold on;
    plot(tarray, abs(x_opt' - x)', '-.');
    grid on;
    title("error x");
    xlabel("t");
    
    nexttile;
    hold on;
    plot(tarray, abs(z_opt' - z)', '-.');
    grid on;
    title("error z");
    xlabel("t");
    
    nexttile;
    hold on;
    plot(tarray, abs(vx_opt' - vx)', '-.');
    grid on;
    title("error vx");
    xlabel("t");
    
    nexttile;
    hold on;
    plot(tarray, abs(vz_opt' - vz)', '-.');
    grid on;
    title("error vz");
    xlabel("t");
    
    nexttile;
    hold on;
    plot(tarray(1:end-1), abs(ux_opt - ux)', '-.');
    grid on;
    title("error ux");
    xlabel("t");
    
    nexttile;
    hold on;
    plot(tarray(1:end-1), abs(uz_opt - uz)', '-.');
    grid on;
    title("error uz");
    xlabel("t");
    
    sgtitle("Absolute Error Trajectories");

end