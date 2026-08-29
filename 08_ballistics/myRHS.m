function  zdot = myRHS(t,z,p)
  m = p.m;
  g = p.g;
  c = p.c;
  
  % Unpacking
  r = z(1:2);
  v = z(3:4);

  % Unit Vectors
  i_hat = [1; 0];
  j_hat = [0; 1];
  v_hat = v / norm(v);

  % Force Balance
  W = m*g * -j_hat;
  F_d = c * -v;
  F_tot = W + F_d;
  
  % ODEs
  r_dot = v;
  v_dot = F_tot / m;
    
  zdot = [r_dot; v_dot];
end
