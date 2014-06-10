function atlas = read_atlas(filename)
% READ ATLAS FROM ATLAS FILE

f = fopen(filename,'r');

atlas.m = fscanf(f,'%u',1);            % Number of variables. Dimension of the ambient space
atlas.k = fscanf(f,'%u',1);            % Dimension of the manifold
atlas.n = fscanf(f,'%u',1);            % Number of equations
atlas.e = fscanf(f,'%lf',1);           % Maximum error for the linear approximation of the manifold.
atlas.ce = fscanf(f,'%lf',1);          % Maximum curvature error between the charts and the manifold
atlas.r = fscanf(f,'%lf',1);           % Radius around p (in tangent space) where the linearization holds
atlas.simpleChart = fscanf(f,'%u',1);  % TRUE if the atlas is to be defined on simple charts
atlas.maxCharts = fscanf(f,'%u',1);    % Maximum number of charts in the atlas
atlas.currentChart = fscanf(f,'%u',1); % Current numer of charts in the atlas

for i=1:atlas.currentChart
   % LOAD CHART
   chart.m = fscanf(f,'%u',1);              % Number of variables. Dimension of the ambient space
   chart.k = fscanf(f,'%u',1);              % Dimension of the manifold
   chart.n = fscanf(f,'%u',1);              % Number of non-redundant equations defining the manifold
   chart.nrJ = fscanf(f,'%u',1);            % Number of equations. Number of rows of the Jacobian.
                                            % This is n for well constrained systems
                                            % and it is larger than n for
                                            % overconstrained systems.
   chart.error = fscanf(f,'%lf',1);         % Maximum error for the linear approximation of the manifold
   chart.eCurv = fscanf(f,'%lf',1);         % Maximum curvature error between the charts and the manifold
   chart.r = fscanf(f,'%lf',1);             % Temptative radius of influence of the chart. This is
                                            % stored in the polytope but we chache it
                                            % here for convenience
   chart.rSample = fscanf(f,'%lf',1);       % ?
   chart.degree = fscanf(f,'%u',1);         % Used to detect bifurcations
   chart.frontier = fscanf(f,'%u',1);       % True for charts with the center out of the domain. Those charts are not to be extended
   chart.singular = fscanf(f,'%u',1);       % TRUE for charts defined on singularities.
                                            % This occurs during branch
                                            % switching. Singular charts do not
                                            % have a Jacobian basis defined
   chart.center =  fscanf(f,'%lf',chart.m); % Linearization point on the manifold
   %chart.center(1:2,:) = 10.*chart.center(1:2,:); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                  %%% THIS DEPENDS ON EACH
                                                  %%% CUIK FILE!!!!
                                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   chart.T = vec2mat(fscanf(f,'%lf',chart.m*chart.k),chart.k); % Basis of the tangent space of the manifold at p (m x k matrix)
   
   chart.flag = fscanf(f,'%u',1);           % ?
   if chart.flag
       chart.BJ = fscanf(f,'%u',chart.nrJ); % TRUE for the rows of the Jacobian that form a basis
   else
       chart.BJ = NaN;
   end
   
   chart.ml = fscanf(f,'%u',1);             % Maximum number of charts linked to this one.
                                            % Singular charts are linked with other
                                            % charts (typically one) representing the
                                            % bifurcation
   if chart.ml>0
       chart.nl = fscanf(f,'%u',1);         % Current number of charts linked with this one
       chart.l = fscanf(f,'%u',chart.nl);   % Identifiers of the linked charts
   else
       chart.nl = 0;
       chart.l = NaN;
   end
   
   % LOAD POLYTOPE
   chart.simple =  fscanf(f,'%u\n',1);
   if chart.simple
       % Load SPolytope
       poly.r = fscanf(f,'%lf',1);                          % radius around p (in tangent space) where the linearization holds
       poly.sr = fscanf(f,'%lf',1);                         % sampling radius
       poly.k = fscanf(f,'%u',1);                           % dimension of the manifold
       
       poly.flag = fscanf(f,'%u',1);                        % ?
       if poly.flag
           % Read Box
           bit = fscanf(f,'%c',1);
           j=1;
           while bit~='}'
               if bit == '['
                   poly.box(j,1) = fscanf(f,'%lf',1);
                   coma = fscanf(f,'%c',1);
                   poly.box(j,2) = fscanf(f,'%lf',1);
                   j = j+1;
               end
               bit = fscanf(f,'%c',1);
           end
           % End Read Box
       end
       
       poly.nFaces = fscanf(f,'%u',1);                      % Num faces defining the polytope so far
       poly.maxFaces = fscanf(f,'%u',1);                    % Space for faces
       if poly.maxFaces>0
           for k = 1:poly.nFaces
               poly.face(k,:) = fscanf(f,'%lf',poly.k+1);   % parameters of the faces defining the polytope
               poly.ID(k) = fscanf(f,'%u',1);               % Identifiers of the neighbouring charts (one per face)
           end               
       else
           poly.face = NaN;
           poly.ID = NaN;
       end
       chart.sp = poly; poly = [];                          % store and empty poly for next iteration
       % End Load SPolytope       
       chart.p = NaN;
   else
       % Load Polytope
         poly.r = fscanf(f,'%lf',1);                                            % Radius around p (in tangent spacee) where the linearization holds.
         poly.k = fscanf(f,'%u',1);                                             % Dimension of the manifold
         poly.emptyPolytope = fscanf(f,'%u',1);                                 % TRUE if the polytope information is initialized.
         if ~poly.emptyPolytope
             poly.nExpandible = fscanf(f,'%u',1);                               % Number of expandible vertices for the chart
             poly.nVertices = fscanf(f,'%u',1);                                 % Number of vertices (if 0 the cart is un-used)
             poly.maxVertices = fscanf(f,'%u',1);                               % Space for vertices
             if poly.maxVertices>0
                 for j=1:poly.maxVertices
                     poly.maxIndices(j) = fscanf(f,'%u',1);                     % Space for facee indices. Also used to link free vertices.
                     if poly.maxIndices(j)>0
                         poly.vertex(j,:) = fscanf(f,'%lf',poly.k);             % Polytope vertices
                         poly.nIndices(j) = fscanf(f,'%u',1);                   % Number of face index per vertex.
                         poly.indices(j,:) = fscanf(f,'%u',poly.nIndices(j));   % Indices of the faces defining a vertex. 
                                                                                % Vertices with k-1 common faces define an edge. 
                                                                                % Edges that cross new faces added to the polytope 
                                                                                % define the new vertices (and the vertices to be removed)
                     else
                         poly.vertex(j,:) = NaN*ones(1,poly.k);
                         poly.indices(j,:) = NaN*ones(1,size(poly.vertex,2));
                         poly.nIndices(j) = fscanf(f,'%u',1);
                     end
                     poly.expandible(j) = fscanf(f,'%u',1);                     % TRUE for that can not be used to expand the chart (vertices out of the chart ball, vertices with some error)
                 end
                 poly.freeVertex = fscanf(f,'%u',1);                            % First free vertex
                 poly.nFaces = fscanf(f,'%u',1);                                % Num faces defining the polytope so far
                 if poly.nFaces>0
                     poly.maxFaces = fscanf(f,'%u',1);                          % Space for faces
                     for j=1:poly.nFaces
                         poly.flag = fscanf(f,'%u',1);                          % ?
                         if poly.flag
                             poly.face(j,:) = fscanf(f,'%lf',poly.k+1);         % Parameters of the faces defining the polytope
                             poly.ID(j) = fscanf(f,'%u',1);                     % Identifiers of the neighbouring charts (one per face)
                         else
                             poly.face(j,:) = NaN*ones(1,poly.k+1);
                             poly.ID(j) = NaN;
                         end
                     end
                 else
                     poly.face = NaN;
                     poly.maxFaces = 0;
                 end
                 % READ BOX
                 bit = fscanf(f,'%c',1);
                 j = 1;
                 while bit ~= '}'
                     if bit == '['
                         poly.box(j,1) = fscanf(f,'%lf',1);
                         coma = fscanf(f,'%c',1);
                         poly.box(j,2) = fscanf(f,'%lf',1);
                         j = j+1;
                     end
                     bit = fscanf(f,'%c',1);
                 end
                 % END READ BOX
             else
                 poly.face = NaN;
                 poly.nFaces = 0;
                 poly.maxFaces = 0;
                 poly.vertex = NaN;
                 poly.nIndices = NaN;
                 poly.maxIndices = NaN;
                 poly.indices = NaN;
                 poly.expandible = NaN;
                 poly.freeVertex = NaN;
             end
         end
       chart.p = poly; poly = []; % store and empty poly for next iteration
       % End Load Polytope
       chart.sp = NaN;
   end
   %End Load Chart
   atlas.charts(i) = chart; chart = []; % store and empty for next iteration       
       
end

fclose(f);
% END READ ATLAS FROM ATLAS FILE