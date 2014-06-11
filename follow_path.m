%path_arduino = read_path(filename);


path_arduino = path_real(3:8,:);


for i = 1:size(path_arduino,2)
    [p,b1,b2,b3,c1,c2,c3,phi,mode] = compute_configuration(path_arduino(:,i),geometry);
       
    % update plot objects
    plot_configuration;mode
    drawnow;
end

