function [pa pb] = twoCircleIntersection(p0,r0,p1,r1)

d = norm(p1-p0);
a = (r0^2 - r1^2 + d^2)/(2*d);
h = sqrt(r0^2 - a^2);
p2 = p0 + a*(p1-p0)/d;

pa = [p2(1) + h * (p1(2) - p0(2))/d ; p2(2) - h * (p1(1) - p0(1))/d];
pb = [p2(1) - h * (p1(2) - p0(2))/d ; p2(2) + h * (p1(1) - p0(1))/d];