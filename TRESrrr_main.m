%%


%load ROBOTICS TOOLBOX by P. CORKE
%cd('/Users/obohigas/IRI/rvctools');
%startup_rvc;

% set current folder
cd('/Users/obohigas/IRI/3RRR-CuikIT');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GRAPHICS INITIALIZATION
%clear all;
fig = figure('Color','w','Name','3-RRR','NumberTitle','off','Position', [7,600,850,600]);
set(fig, 'MenuBar','none');%, 'BackingStore', 'off','renderer','opengl');
%set(gca, 'drawmode','fast');
axis off;
%subplot('Position', [0.08,0.1,0.6,0.85]);
%subplot('Position', [0.01 0.01 0.99 0.99]);
axes('position', [-0.135 0.01 0.98 0.98])
axis equal; 
axis([-20 40 -20 40]); %grid;
set(gca,'XTick',[],'YTick',[]);
box on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
p = [0.3 -0.9+sqrt(3)*1.2/6]'.*10;
phi = 0;
t1 = 2.860699552127036;
t2 = -1.674302990638046;
t3 = -1.442766936542316;

% compute other variables needed to plot
R = [cos(phi) -sin(phi);sin(phi) cos(phi)]; % r'=Rr
b1 = p+R*B1; % platform joints in fixed frame
b2 = p+R*B2;
b3 = p+R*B3;
c1 = a1 + L1*[cos(t1);sin(t1)]; % middle joints
c2 = a2 + L1*[cos(t2);sin(t2)];
c3 = a3 + L1*[cos(t3);sin(t3)];

% obtain mode to plot the appropriate singularities
p1 =  atan2(b1(2)-c1(2),b1(1)-c1(1)); % absolute angle of intermediate joints
p2 =  atan2(b2(2)-c2(2),b2(1)-c2(1));
p3 =  atan2(b3(2)-c3(2),b3(1)-c3(1));
mode = '';
mode(1) = num2str( sign(cos(t1)*sin(p1) - cos(p1)*sin(t1))/2 + 3/2 ); % sign gives + -> 1 and - -> -1. This is the formula to get + -> 2 and - -> 1
mode(2) = num2str( sign(cos(t2)*sin(p2) - cos(p2)*sin(t2))/2 + 3/2 );
mode(3) = num2str( sign(cos(t3)*sin(p3) - cos(p3)*sin(t3))/2 + 3/2 );

geometry.base = [a1 a2 a3];
geometry.platform = [B1 B2 B3];
geometry.L1 = L1;
geometry.L2 = L2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%atlas = read_atlas('3rrr.atlas');
%g = atlas2graph(atlas);
delta_ws = 0.01;
delta_sing = 2*pi/360;
%load('workspaces','workspaces');
%load('singularities','singularities');
eps_valid = 1e-5;
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT OBJECTS
% (order of creation of each object --> depth in the plot, first created is
% in the back, last created in the front)
workspace = line('color',[0.7,0.7,0.7],'LineStyle','-','linewidth',2);
sings = line('color','r','LineStyle','.','markersize',5);
platform = line('color',[.5,0,0],'LineWidth',1);
P = line('color','k','marker','*');
leg1 = line('color','b');
leg2 = line('color','b');
leg3 = line('color','b');
base = line('color','k','marker','o','linestyle','none');
set(base,'xdata',[a1(1) a2(1) a3(1)],'ydata',[a1(2) a2(2) a3(2)]); % this is set here because its constant, no need to update

plot_configuration;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROLS
slider_phi = uicontrol(fig,'Style','slider','Pos',[600 150 200 17],...
   'Min',0,'Max',360,'SliderStep',[1/360 1/360],...
   'Val',0,'CallBack',['phi=get(slider_phi,''Val'')*pi/180;'...
   '[p,b1,b2,b3,c1,c2,c3] = compute_configuration_from_xyphi(p(1),p(2),phi,mode,geometry);'...
   'plot_configuration;']);

%% select start
phi = 0; % for now, constant orientation

q_start = line('color','c','marker','o','xdata',100,'ydata',100);
[n_start,x_start,y_start] = g.pick();
set(q_start,'xdata',x_start,'ydata',y_start);
[p,b1,b2,b3,c1,c2,c3] = compute_configuration_from_xyphi(x_start,y_start,phi,mode,geometry);
plot_configuration;

% select goal
q_goal = line('color','g','marker','o','xdata',100,'ydata',100);
[n_goal,x_goal,y_goal] = g.pick();
set(q_goal,'xdata',x_goal,'ydata',y_goal);
[p,b1,b2,b3,c1,c2,c3] = compute_configuration_from_xyphi(x_start,y_start,phi,mode,geometry);
plot_configuration;

% compute path as ordered list of nodes
path_nodes = g.Astar(n_start,n_goal);

% plot path
g.highlight_path(path_nodes,'NodeSize',4,'EdgeColor',[1 0.5 0]);

path_real = zeros(9,length(path_nodes));
% get real path (variables of interest)
for i=1:length(path_nodes)
    path_real(:,i) = g.coord(path_nodes(i));
end

follow_path;





