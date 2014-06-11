% pick_conf function


[node,x,y,t1,t2,t3,p1,p2,p3] = g.pick(phi,mode,geometry);
conf_picked = [x,y,t1,t2,t3,p1,p2,p3]';
node_coordinates = g.coord(node);
[p,b1,b2,b3,c1,c2,c3,phi,mode_computed] = compute_configuration(node_coordinates(3:8),geometry);
plot_configuration;