function zalldot = rhs(t, zall, u, p)
    [g, zinit, zfinal, numPoints, tspan] = unpack_p(p);
    % [x, z, vx, vz] = unpack_z(zall);

    x = zall(1);
    z = zall(2);
    vx = zall(3);
    vz = zall(4);

    ux = u(1); uz = u(2);

    xdot = vx;
    zdot = vz;
    vxdot = ux;
    vzdot = uz - g;

    zalldot = [xdot; zdot; vxdot; vzdot];
end