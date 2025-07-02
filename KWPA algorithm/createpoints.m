%初始化节点分布以及生成无向图
function [posi_all,xmin,xmax,ymin,ymax,zmin,zmax] = createpoints(npoints,min_distance,num_m,v_min,v_max)


%初始化节点生成的三维区域大小范围
[xmin,xmax,ymin,ymax,zmin,zmax,num_subswarm]=AREA(npoints);
if num_subswarm==1
    [posi_all] = sub_cp(xmin,xmax,ymin,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
elseif num_subswarm==2
    [posi_all(:,1:npoints/2,:)] = sub_cp(xmin,xmax/2,ymin,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/2+1:npoints,:)] = sub_cp(xmax/2,xmax,ymin,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
elseif num_subswarm==3
    [posi_all(:,1:npoints/4,:)] = sub_cp(xmin,xmax/2,ymin,ymax/2,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/4+1:npoints/2,:)] = sub_cp(xmax/2,xmax,ymin,ymax/2,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/2+1:npoints/4*3,:)] = sub_cp(xmin,xmax/2,ymax/2,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/4*3+1:npoints,:)] = sub_cp(xmax/2,xmax,ymax/2,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
elseif num_subswarm==4
    [posi_all(:,1:npoints/4,:)] = sub_cp(xmin,xmax/2,ymin,ymax/2,zmin,zmax/2,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/4+1:npoints/2,:)] = sub_cp(xmax/2,xmax,ymin,ymax/2,zmin,zmax/2,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/2+1:npoints/4*3,:)] = sub_cp(xmin,xmax/2,ymax/2,ymax,zmin,zmax/2,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/4*3+1:npoints,:)] = sub_cp(xmax/2,xmax,ymax/2,ymax,zmin,zmax/2,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,1:npoints/4,:)] = sub_cp(xmin,xmax/2,ymin,ymax/2,zmax/2,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/4+1:npoints/2,:)] = sub_cp(xmax/2,xmax,ymin,ymax/2,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/2+1:npoints/4*3,:)] = sub_cp(xmin,xmax/2,ymax/2,ymax,zmax/2,zmax,npoints,num_m,min_distance,v_min,v_max);
    [posi_all(:,npoints/4*3+1:npoints,:)] = sub_cp(xmax/2,xmax,ymax/2,ymax,zmax/2,zmax,npoints,num_m,min_distance,v_min,v_max);
end


end