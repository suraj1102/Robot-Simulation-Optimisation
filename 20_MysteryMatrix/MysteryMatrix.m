clear; clc; close all;


m = 3;
A = myDetective(m)

function myA = myDetective(m)
    myA = [];
    for i = 1:m
        v = zeros(m,1);
        v(i) = 1;
        u = andymatrix(v);
        myA = [myA, u];
    end
end


function u = andymatrix(v)
    % A is a nxm. You are given m
    A = [
            1, 2, 3;
            4, 5, 6;
            7, 8, 9;
        ];
    
    u = A * v;
end