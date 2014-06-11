function [X_wsp,Y_wsp] = compute_workspace(phi,geometry)
% created from Workspace.m by Ilian Bonev in RRR.zip package from
% parallemic website

O = geometry.base;
Bp = geometry.platform;
rA = geometry.L1;
l = geometry.L2;

R = [ cos(phi), -sin(phi); sin(phi), cos(phi)];

% DEFINITION OF INNER AND OUTER CIRCLES-----------------------------------------
 for i = 1:3,
   circle{i}(1).geom = [(O(:,i)-R*Bp(:,i))',l+rA];
   circle{i}(1).intpts = [];
   circle{i}(1).arcpts = [];
   if l ~= rA,
     circle{i}(2).geom = [(O(:,i)-R*Bp(:,i))',abs(l-rA)];
     circle{i}(2).intpts = [];
     circle{i}(2).arcpts = [];
   end;
 end;

% OBTAINING THE INTERSECTION POINTS BETWEEN ALL PAIRS OF CIRCLES----------------
 for i = 1:2,
   for j = (i+1):3,
     for ii = 1:length(circle{i}),
       for jj = 1:length(circle{j}),
	     xci = circle{i}(ii).geom(1);
         yci = circle{i}(ii).geom(2);
         xcj = circle{j}(jj).geom(1);
         ycj = circle{j}(jj).geom(2);
         ri = circle{i}(ii).geom(3);
         rj = circle{j}(jj).geom(3);
         d = sqrt((xcj-xci)^2+(ycj-yci)^2); % distance between centers
         if (d < ri+rj),
           temp1 = d^2-2*rj*(xcj-xci)+rj^2-ri^2;
           temp2 = 4*rj*(ycj-yci);
           temp3 = d^2+2*rj*(xcj-xci)+rj^2-ri^2;
           T1 = (-temp2+sqrt(temp2^2-4*temp1*temp3))/(2*temp1);
           T2 = (-temp2-sqrt(temp2^2-4*temp1*temp3))/(2*temp1);
           etaj1 = 2*atan(T1); etaj1 = atan2(sin(etaj1),cos(etaj1));
           etaj2 = 2*atan(T2); etaj2 = atan2(sin(etaj2),cos(etaj2));
           x1 = xcj+rj*cos(etaj1);
           y1 = ycj+rj*sin(etaj1);
           x2 = xcj+rj*cos(etaj2);
           y2 = ycj+rj*sin(etaj2);
           etai1 = atan2((y1-yci)/ri,(x1-xci)/ri);
           etai2 = atan2((y2-yci)/ri,(x2-xci)/ri);
           circle{i}(ii).intpts(end+1:end+2) = [etai1, etai2];
           circle{j}(jj).intpts(end+1:end+2) = [etaj1, etaj2];
         end
       end;
     end;
   end;
 end;
 
% SORT THE INTERSECTION POINTS--------------------------------------------------
 for i = 1:3,
   for ii = 1:length(circle{i}),
     circle{i}(ii).intpts(circle{i}(ii).intpts<0) = ...
	 circle{i}(ii).intpts(circle{i}(ii).intpts<0) + 2*pi;
     circle{i}(ii).intpts = sort(circle{i}(ii).intpts);
     if ~isempty(circle{i}(ii).intpts),
       circle{i}(ii).intpts(end+1) = circle{i}(ii).intpts(1);
     else
       % in order to check for circles that are completely inside
       % outer circles and outside inner ones
       circle{i}(ii).intpts = [0, 2*pi];
     end;
   end;
 end;
 
% CHECK ALL RESULTING ARCS------------------------------------------------------
 for i = 1:3,
   for ii = 1:length(circle{i}),
     for iii = 1:length(circle{i}(ii).intpts)-1,
       u1 = circle{i}(ii).intpts(iii);
       u2 = circle{i}(ii).intpts(iii+1);
       alpha = atan2(sin(u2-u1),cos(u2-u1));
       if (alpha<0),
         alpha = alpha+2*pi;
       end;
       % center of current arc
       temp = u1+alpha/2;
       x = circle{i}(ii).geom(1)+circle{i}(ii).geom(3)*cos(temp);
       y = circle{i}(ii).geom(2)+circle{i}(ii).geom(3)*sin(temp);
       % check whether point (x,y) is inside all other annuli
       j_set = setdiff(1:3,i);
       flag = [];
       for ind_j = 1:(3-1),
         j = j_set(ind_j);
	 % distance from current point to center of j-th annulus
         dd = sqrt((x-circle{j}(1).geom(1))^2+(y-circle{j}(1).geom(2))^2);
         if (length(circle{i}) == 2),
           flag(end+1) = ((dd >= circle{j}(2).geom(3)) & ...
		         (dd <= circle{j}(1).geom(3)));
	 else
	   flag(end+1) = (dd <= circle{j}(1).geom(3));
	 end;
       end;
       if ~any(~flag),
         circle{i}(ii).arcpts(:,end+1) = [u1;u2];
       end;
     end;
   end;
 end;

% CONSTANT-ORIENTATION WORKSPACE---------------------------------------
 % initialize workspace array
 X_wsp = []; Y_wsp = [];
 for i = 1:3,
   for ii = 1:length(circle{i}),
     for iii = 1:size(circle{i}(ii).arcpts,2),
       ang1 = circle{i}(ii).arcpts(1,iii);
       ang2 = circle{i}(ii).arcpts(2,iii);
       if (ang1 > ang2),
         ang = [ang1:0.01:2*pi, 0:0.01:ang2];
       else
	   ang = [ang1:0.01:ang2];
       end;
       ang(end+1) = ang2(end);
       X_wsp = [X_wsp, circle{i}(ii).geom(1)+circle{i}(ii).geom(3)* ...
		cos(ang), NaN];        
       Y_wsp = [Y_wsp, circle{i}(ii).geom(2)+circle{i}(ii).geom(3)* ...
		sin(ang), NaN];
     end;
   end;
 end;