% plot configuration (including workspace and singularities) by updating
% values
index_ws = round( (phi/delta_ws) )+1;
index_sing = round( (phi/delta_sing) )+1;
if ~isempty(workspaces{index_ws})
    set(workspace,'xdata',workspaces{index_ws}(1,:),'ydata',workspaces{index_ws}(2,:));
end
if ~isempty(singularities.(['m' mode]){index_sing})
        set(sings,'xdata',singularities.(['m' mode]){index_sing}(1,:).*10,'ydata',singularities.(['m' mode]){index_sing}(2,:).*10);
end
set(P,'xdata',p(1),'ydata',p(2));
set(leg1,'xdata',[a1(1) c1(1) b1(1)],'ydata',[a1(2) c1(2) b1(2)]);
set(leg2,'xdata',[a2(1) c2(1) b2(1)],'ydata',[a2(2) c2(2) b2(2)]);
set(leg3,'xdata',[a3(1) c3(1) b3(1)],'ydata',[a3(2) c3(2) b3(2)]);
set(platform,'xdata',[b1(1) b2(1) b3(1) b1(1)],'ydata',[b1(2) b2(2) b3(2) b1(2)]);