syms L1 L2 a1x a1y a2x a2y a3x a3y d alpha % constants
syms phi t1 t2 t3 p1 p2 p3 x y % vars, even if working in fixed orientation, phi is constant
eqs= [a1x + L1*cos(t1) + L2*cos(p1) + d*cos(phi)*cos(alpha/2) - d*sin(phi)*sin(alpha/2) - x;...
      a1y + L1*sin(t1) + L2*sin(p1) + d*sin(phi)*cos(alpha/2) + d*cos(phi)*sin(alpha/2) - y;...
      a2x + L1*cos(t2) + L2*cos(p2) - d*cos(phi)*cos(alpha/2) - d*sin(phi)*sin(alpha/2) - x;...
      a2y + L1*sin(t2) + L2*sin(p2) - d*sin(phi)*cos(alpha/2) + d*cos(phi)*sin(alpha/2) - y;...
      a3x + L1*cos(t3) + L2*cos(p3) + d*sin(phi) - x;...
      a3y + L1*sin(t3) + L2*sin(p3) - d*cos(phi) - y];
  
Jeqs = jacobian(eqs,[x y phi p1 p2 p3]); 
sing_equation = det(Jeqs)