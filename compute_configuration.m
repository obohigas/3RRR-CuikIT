function [p,b1,b2,b3,c1,c2,c3,phi,mode] = compute_configuration(angles,geometry)
% compute configuration from values provided by the physical platform,
% namely absolute angles at the motors and relative angles at the
% intermediate joints (NOW IT ASSUMES ABSOLUTE ANGLES AT THE INTERMEDIATE
% JOINTS ARE GIVEN)

a1 = geometry.base(:,1);
a2 = geometry.base(:,2);
a3 = geometry.base(:,3);
B1 = geometry.platform(:,1);

L1 = geometry.L1;
L2 = geometry.L2;

t1 = angles(1);
t2 = angles(2);
t3 = angles(3);
p1 = angles(4);%+theta1;
p2 = angles(5);%+theta2;
p3 = angles(6);%+theta3;

c1 = a1 + L1*[cos(t1);sin(t1)];
c2 = a2 + L1*[cos(t2);sin(t2)];
c3 = a3 + L1*[cos(t3);sin(t3)];

b1 = c1 + L2*[cos(p1);sin(p1)];
b2 = c2 + L2*[cos(p2);sin(p2)];
b3 = c3 + L2*[cos(p3);sin(p3)];

phi = atan2(b2(2)-b1(2),b2(1)-b1(1));
if phi<0 % this is to avoid negative values of phi
    phi = 2*pi+phi;
end
R = [ cos(phi), -sin(phi); sin(phi), cos(phi)];
p = b1 - R*B1;

mode = '000';
if cos(t1)*sin(p1)-cos(p1)*sin(t1) >=0
    mode(1)='2';
else
    mode(1)='1';
end
if cos(t2)*sin(p2)-cos(p2)*sin(t2) >=0
    mode(2)='2';
else
    mode(2)='1';
end
if cos(t3)*sin(p3)-cos(p3)*sin(t3) >=0
    mode(3)='2';
else
    mode(3)='1';
end
