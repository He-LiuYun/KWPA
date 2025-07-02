function region_list = divide_space_by_combin(xmin, xmax, ymin, ymax, zmin, zmax, combin)
    x_edges = linspace(xmin, xmax, combin(1)+1);
    y_edges = linspace(ymin, ymax, combin(2)+1);
    z_edges = linspace(zmin, zmax, combin(3)+1);
    
    region_list = {};
    index = 1;
    for i = 1:combin(1)
        for j = 1:combin(2)
            for k = 1:combin(3)
                region_list{index}.x = [x_edges(i), x_edges(i+1)];
                region_list{index}.y = [y_edges(j), y_edges(j+1)];
                region_list{index}.z = [z_edges(k), z_edges(k+1)];
                index = index + 1;
            end
        end
    end
end
