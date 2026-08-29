function  zdot = myRHS(t,z,p)
  m = p.m;
  g = p.g;
  k = p.k;
  l0 = p.l0;
  
  % Unpacking
  x = z(1);
  vx = z(2);
  y = z(3);
  vy = z(4);

  % Forces
  L = sqrt(x^2 + y^2);
  T = k * (L - l0);

  % ODEs
  x_dot = vx;
  vx_dot = -(T/L * x) * 1/m;
  y_dot = vy;
  vy_dot = -(T/L * x + m*g) * 1/m;
    
  zdot = [x_dot, vx_dot, y_dot, vy_dot];
end
