% set_goal function

n_goal=node;
x_goal=x;
y_goal=y;
set(q_goal,'xdata',x_goal,'ydata',y_goal);
path_nodes = g.Astar(n_start,n_goal);
g.highlight_path(path_nodes,'NodeSize',4,'EdgeColor',[1 0.5 0]);