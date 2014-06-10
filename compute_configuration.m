function [p,b1,b2,b3,c1,c2,c3,phi] = compute_configuration(angles,geometry)

a1 = geometry.base(:,1);
a2 = geometry.base(:,2);
a3 = geometry.base(:,3);
B1 = geometry.platform(:,1);

L1 = geometry.L1;
L2 = geometry.L2;

theta1 = angles(1);
theta2 = angles(2);
theta3 = angles(3);
abs1 = angles(4)+theta1;
abs2 = angles(5)+theta2;
abs3 = angles(6)+theta3;

c1 = a1 + L1*[cos(theta1);sin(theta1)];
c2 = a2 + L1*[cos(theta2);sin(theta2)];
c3 = a3 + L1*[cos(theta3);sin(theta3)];

b1 = c1 + L2*[cos(abs1);sin(abs1)];
b2 = c2 + L2*[cos(abs2);sin(abs2)];
b3 = c3 + L2*[cos(abs3);sin(abs3)];

phi = atan2(b2(2)-b1(2),b2(1)-b1(1));
if phi<0 % this is to avoid negative values of phi
    phi = 2*pi+phi;
end
R = [ cos(phi), -sin(phi); sin(phi), cos(phi)];
p = b1 - R*B1;
