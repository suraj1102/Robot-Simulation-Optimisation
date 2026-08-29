function [g, zinit, zfinal, numPoints, tspan] = unpack_p(p)
    g = p.g;
    zinit = p.zinit;
    zfinal = p.zfinal;
    numPoints = p.numPoints;
    tspan = p.tspan;
end