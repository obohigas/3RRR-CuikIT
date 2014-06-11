%% plot reachable
disp('start');
hold on;
phi = 0:0.01:2*pi;
for i=1:length(phi)
    
    %[p,b1,b2,b3,c1,c2,c3,phi] = compute_configuration(path_arduino(:,i),geometry);
    index_ws = round( (phi(i)/delta_ws)+1 );
    if ~isempty(workspaces{index_ws})
        plot(workspaces{index_ws}(1,:),workspaces{index_ws}(2,:));
        %set(workspace,'xdata',workspaces{index_ws}(1,:),'ydata',workspaces{index_ws}(2,:));
    end
    set(platform,'xdata',[b1(1) b2(1) b3(1) b1(1)],'ydata',[b1(2) b2(2) b3(2) b1(2)]);
    set(P,'xdata',p(1),'ydata',p(2));
    set(base,'xdata',[a1(1) a2(1) a3(1)],'ydata',[a1(2) a2(2) a3(2)]);
    set(leg1,'xdata',[a1(1) c1(1) b1(1)],'ydata',[a1(2) c1(2) b1(2)]);
    set(leg2,'xdata',[a2(1) c2(1) b2(1)],'ydata',[a2(2) c2(2) b2(2)]);
    set(leg3,'xdata',[a3(1) c3(1) b3(1)],'ydata',[a3(2) c3(2) b3(2)]);
    drawnow;
end
disp('done');