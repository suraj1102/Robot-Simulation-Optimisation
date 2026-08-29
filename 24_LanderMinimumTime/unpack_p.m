function [g, zinit, zfinal, numPoints] = unpack_p(p)
    g = p.g;
    zinit = p.zinit;
    zfinal = p.zfinal;
    numPoints = p.numPoints;
end