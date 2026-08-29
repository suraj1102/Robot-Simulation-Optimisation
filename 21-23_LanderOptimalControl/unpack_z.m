function [x, z, vx, vz] = unpack_z(zall)
    x = zall(1, :);
    z = zall(2, :);
    vx = zall(3, :);
    vz = zall(4, :);
end