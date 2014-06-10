function g = atlas2graph(atlas)
% CREATE GRAPH

g = PGraph(atlas.m,'distance','3RRR'); % create graph of dimension the number of variables

%%%%% FALTA CANVIAR DISTANCIA  %%%%%%%

% add nodes
for i=1:atlas.currentChart
    atlas.charts(i).center(1:2) = atlas.charts(i).center(1:2).*10;
    g.add_node(atlas.charts(i).center); % each node added gets an id assigned by order (1, 2, 3, ...).
                                          % In variable atlas, charts are numbered from 0.
                                          % In g (graph) nodes are numbered from 1
end

% add edges
for i=1:atlas.currentChart
    neighbours = atlas.charts(i).p.ID(~isnan(atlas.charts(i).p.ID).*atlas.charts(i).p.ID<=atlas.currentChart)+1;
    for j=1:length(neighbours)
        g.add_edge(i,neighbours(j));
    end
end