function [posi_all,xmin,xmax,ymin,ymax,zmin,zmax] = point_move(npoints, min_distance, num_m, v_min, v_max)
%初始化节点生成的三维区域大小范围
    [xmin,xmax,ymin,ymax,zmin,zmax]=AREA(npoints);
    posi_all=sub_cp(xmin,xmax,ymin,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
end


