%path_arduino = read_path(filename);
%filename='3rrr_free';
%follow_path;

path_arduino = path_real(3:8,:);

for i = 1:2:size(path_arduino,2)
    [p,b1,b2,b3,c1,c2,c3,phi] = compute_configuration(path_arduino(:,i),geometry);
       
    % update plot objects
    plot_configuration;
    drawnow;
end

