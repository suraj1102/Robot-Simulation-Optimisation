%myrhs.m
function zdot = myrhs(z,p);
% Right hand side of odes, that is: 
%  the function f in the ODEs:   zdot = f(z)
% In this case, a mass hanging from two springs in parallel
% with two dashpots
% The whole folder is about figureing out features of this function.
packunpack(p);  % p is a struct holding all parameters

%unpack z  %  z is the 4 element state vector z = [r;v].
rC = z(1:2);  % position of moving mass at C
vC = z(3:4);

i = [1 0]'; j = [0 1]';
rAC = rC - rA;  LAC = norm(rAC); lambdaAC = rAC/LAC;
rBC = rC - rB;  LBC = norm(rBC); lambdaBC = rBC/LBC;

LACdot = dot(vC, lambdaAC);  % rate of change of length of AC
LBCdot = dot(vC, lambdaBC);  % rate of change of length of BC

Ftot = -kA  * ( LAC-LA) * lambdaAC ...% spring  A
       -cA  *  LACdot   * lambdaAC ...% dashpot A
       -kB  * (LBC-LB)  * lambdaBC ...% spring  B
       -cB  *  LBCdot   * lambdaBC ...% dashpot B
       -c   *  vC                  ...% viscous drag c
       -m*g *               j     ;   % gravity

rCdot = vC;
vCdot = Ftot/m;

zdot = [rCdot;
        vCdot];

end