function cost = costFunction(zfmin, problem)
    [x, z, vx, vz, ux, uz, T] = unpack_zfmin(zfmin, problem);
    
    cost = T;
end
