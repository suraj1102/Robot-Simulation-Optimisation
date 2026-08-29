function cost = MPCCostFunction(zmpc, zfmin_opt, p, k)
    [xopt, zopt, vxopt, vzopt, uxopt, uzopt] = unpack_zfmin(zfmin_opt, p);
    [x, z, vx, vz, ux, uz] = unpack_zmpc(zmpc, p);
    
    Np = p.Np;
    
    % Reference sliding window
    idx_end_state = min(k + Np, length(xopt));
    idx_end_ctrl  = min(k + Np - 1, length(uxopt));
    
    xref  = xopt(k:idx_end_state);
    zref  = zopt(k:idx_end_state);
    vxref = vxopt(k:idx_end_state);
    vzref = vzopt(k:idx_end_state);
    
    uxref = uxopt(k:idx_end_ctrl);
    uzref = uzopt(k:idx_end_ctrl);
    
    % Pad reference
    while length(xref) < (Np + 1)
        xref(end+1)   = xopt(end);
        zref(end+1)   = zopt(end);
        vxref(end+1)  = vxopt(end);
        vzref(end+1)  = vzopt(end);
    end
    
    while length(uxref) < Np
        uxref(end+1)  = uxopt(end);
        uzref(end+1)  = uzopt(end);
    end
    
    % Costs
    Q = p.Q;
    R = p.R;
    cost = 0;
    
    for i = 1:Np
        % x - xref
        dx = [x(i); z(i); vx(i); vz(i)] - [xref(i); zref(i); vxref(i); vzref(i)];
        
        % u - uref
        du = [ux(i); uz(i)] - [uxref(i); uzref(i)];
        
        % x'Qx + u'Ru
        cost = cost + (dx' * Q * dx) + (du' * R * du);
    end
    
    % Terminal Cost
    dxT = [x(Np+1); z(Np+1); vx(Np+1); vz(Np+1)] - [xopt(end); zopt(end); vxopt(end); vzopt(end)];
    cost = cost + (dxT' * diag([0,0,0,0]) * dxT);
    
    cost = cost * p.dtp;
end