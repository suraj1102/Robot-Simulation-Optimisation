function  zdot = myRHS(t,z,p)
  m = p.m;
  g = p.g;

  b1 = p.b1;
  b2 = p.b2;
  d = p.d; % drag coef
  k1 = p.k1;
  k2 = p.k2;
  l1_0 = p.l1_0;
  l2_0 = p.l2_0;
  
  r1 = p.r1;
  r2 = p.r2;


  % States
  r = z(1:2); % Mass Position Vec
  v = z(3:4);


  % Unit Vectors
  i_hat = [1; 0];
  j_hat = [0; 1];
  
  l1 = norm(r - r1);
  lambda1_hat = (r - r1) / l1;

  l2 = norm(r - r2);
  lambda2_hat = (r - r2) / l2;

  % Spring K1
  F_k1 = k1 * (l1 - l1_0) * -lambda1_hat;
  F_k2 = k2 * (l2 - l2_0) * -lambda2_hat;

  % Check signs later from animation
  F_b1 = b1 * dot(v, lambda1_hat) * -lambda1_hat;
  F_b2 = b2 * dot(v, lambda2_hat) * -lambda2_hat;
   
  F_d = d * -v;
  
  W = m*g* -j_hat;

  F_net = F_k1 + F_k2 + F_b1 + F_b2 + F_d + W;
  a = F_net / m;

  
  % ODEs
  r_dot = v;
  v_dot = a;
    
  zdot = [r_dot; v_dot];
end
