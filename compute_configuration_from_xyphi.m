function [p,b1,b2,b3,c1,c2,c3] = compute_configuration_from_xyphi(x,y,phi,mode,geometry)
% compute configuration from x, y, and phi (for now, only mode 211 is assumed)

a1 = geometry.base(:,1);
a2 = geometry.base(:,2);
a3 = geometry.base(:,3);
B1 = geometry.platform(:,1);
B2 = geometry.platform(:,2);
B3 = geometry.platform(:,3);

L1 = geometry.L1;
L2 = geometry.L2;

p = [x y]';
R = [ cos(phi), -sin(phi); sin(phi), cos(phi)];
b1 = p + R*B1;
b2 = p + R*B2;
b3 = p + R*B3;

[c1a c1b] = twoCircleIntersection(a1,L1,b1,L2);
mode_a = sign(det([c1a(1)-a1(1) b1(1)-c1a(1) ; c1a(2)-a1(2) b1(2)-c1a(2)]));
if (mode_a==1 && mode(1)=='2') || (mode_a==-1 && mode(1)=='1')
    c1 = c1a;
else 
    c1 = c1b;
end

[c2a c2b] = twoCircleIntersection(a2,L1,b2,L2);
mode_a = sign(det([c2a(1)-a2(1) b2(1)-c2a(1) ; c2a(2)-a2(2) b2(2)-c2a(2)]));
if (mode_a==1 && mode(2)=='2') || (mode_a==-1 && mode(2)=='1')
    c2 = c2a;
else 
    c2 = c2b;
end

[c3a c3b] = twoCircleIntersection(a3,L1,b3,L2);
mode_a = sign(det([c3a(1)-a3(1) b3(1)-c3a(1) ; c3a(2)-a3(2) b3(2)-c3a(2)]));
if (mode_a==1 && mode(3)=='2') || (mode_a==-1 && mode(3)=='1')
    c3 = c3a;
else 
    c3 = c3b;
end

