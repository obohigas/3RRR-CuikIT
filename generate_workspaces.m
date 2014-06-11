%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BONEV'S GEOMETRIC PARAMETERS
a1 = [0     0]';
a2 = [23.5  0]';
a3 = [11.75 20.35]';

% reference point P is at the center of the platform (equilater triangle of side 12)
B1 = [-6 -2*sqrt(3)]'; % 2*sqrt(3) comes from sqrt(3)*a/6, being a=12 side of the triangle
B2 = [ 6 -2*sqrt(3)]';
B3 = [ 0  4*sqrt(3)]'; % 4*sqrt(3) comes from sqrt(3)*a/3, being a=12 side of the triangle

L1 = 10;
L2 = 13.5;

% home position
p = [1 0.9391392855382411]'.*10;
phi = 0;
theta1 = -0.812979554930007;
theta2 = -2.287384585735865;
theta3 = 1.933538202108294;
R = [cos(phi) -sin(phi);sin(phi) cos(phi)]; % r'=Rr

b1 = p+R*B1; % platform joints in fixed frame
b2 = p+R*B2;
b3 = p+R*B3;
c1 = a1 + L1*[cos(theta1);sin(theta1)]; % middle joints
c2 = a2 + L1*[cos(theta2);sin(theta2)];
c3 = a3 + L1*[cos(theta3);sin(theta3)];

geometry.base = [a1 a2 a3];
geometry.platform = [B1 B2 B3];
geometry.L1 = L1;
geometry.L2 = L2;

% variable to store workspaces
workspaces = {};
figure();
workspace = line('color',[0.7,0.7,0.7],'LineStyle','-','erasemode','xor');

delta = 0.01;
phi = 0:delta:2*pi;
for i=1:length(phi)
    [X_workspace,Y_workspace] = compute_workspace(phi(i),geometry);
    workspaces{i} = [X_workspace;Y_workspace];
    %set(workspace,'xdata',X_workspace,'ydata',Y_workspace);
    %drawnow;
    %pause(0.05);
end
disp('fet');

save('workspaces','workspaces');