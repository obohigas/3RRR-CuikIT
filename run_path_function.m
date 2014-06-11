% run_path function

path_real = zeros(8,length(path_nodes));
for i=1:length(path_nodes)
    path_real(:,i) = g.coord(path_nodes(i)); 
end
follow_path;
