%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEOMETRIC PARAMETERS
a1 = [30   0]';
a2 = [ 0  30]';
a3 = [ 0   0]';

B1 = [ 12/2 -sqrt(3)*12/6]';
B2 = [ 0     sqrt(3)*12/3]';
B3 = [-12/2 -sqrt(3)*12/6]';

L1 = 10;
L2 = 12;

%%%%%%%%%%%%%%%
% normalization for better performance of cuik (de-normalize the output before plotting!)
a1 = a1/10;
a2 = a2/10; 
a3 = a3/10;
B1 = B1/10;
B2 = B2/10; 
B3 = B3/10; 
L1 = L1/10;
L2 = L2/10;
%%%%%%%%%%%%%%%

phi = 0;

% possible modes: 111
%                 112
%                 121
%                 122
%                 211
%                 212
%                 221
%                 222
% 1 -> -   2 -> +
% for now, we use only one mode / we will loop on all modes afterwards
mode = 111;


%% get singularities

N = length(phi);

tic
for i=1:N
    disp(['step ' int2str(i) ' of ' int2str(N)]);
    singularitats{i} = compute_singF_constOrient(phi(i),mode(i));
end

toc