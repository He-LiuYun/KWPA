function [posi_all,xmin,xmax,ymin,ymax,zmin,zmax,num_subswarm,idx] = simplified_boids(npoints, min_distance, num_m, v_min, v_max)
%初始化节点生成的三维区域大小范围
[xmin,xmax,ymin,ymax,zmin,zmax,num_subswarm]=AREA(npoints);
if num_subswarm==1
    [posi_all] = sub_cp(xmin,xmax,ymin,ymax,zmin,zmax,npoints,num_m,min_distance,v_min,v_max);idx(1:npoints,1)=1;
elseif num_subswarm==2
    [posi_all(:,1:npoints/2,:)] = sub_cp(xmin,xmax/2,ymin,ymax,zmin,zmax,npoints/2,num_m,min_distance,v_min,v_max);idx(1:npoints/2,1)=1;
    [posi_all(:,npoints/2+1:npoints,:)] = sub_cp(xmax/2,xmax,ymin,ymax,zmin,zmax,npoints/2,num_m,min_distance,v_min,v_max);idx(npoints/2+1:npoints,1)=2;
elseif num_subswarm==4
    [posi_all(:,1:npoints/4,:)] = sub_cp(xmin,xmax/2,ymin,ymax/2,zmin,zmax,npoints/4,num_m,min_distance,v_min,v_max);idx(1:npoints/4,1)=1;
    [posi_all(:,npoints/4+1:npoints/2,:)] = sub_cp(xmax/2,xmax,ymin,ymax/2,zmin,zmax,npoints/4,num_m,min_distance,v_min,v_max);idx(npoints/4+1:npoints/2,1)=1;
    [posi_all(:,npoints/2+1:npoints/4*3,:)] = sub_cp(xmin,xmax/2,ymax/2,ymax,zmin,zmax,npoints/4,num_m,min_distance,v_min,v_max);idx(npoints/2+1:npoints/4*3,1)=1;
    [posi_all(:,npoints/4*3+1:npoints,:)] = sub_cp(xmax/2,xmax,ymax/2,ymax,zmin,zmax,npoints/4,num_m,min_distance,v_min,v_max);idx(npoints/4*3+1:npoints,1)=1;
elseif num_subswarm==8
    [posi_all(:,1:npoints/8,:)] = sub_cp(xmin,xmax/2,ymin,ymax/2,zmin,zmax/2,npoints/8,num_m,min_distance,v_min,v_max);idx(1:npoints/8,1)=1;
    [posi_all(:,npoints/8+1:npoints/4,:)] = sub_cp(xmax/2,xmax,ymin,ymax/2,zmin,zmax/2,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/8+1:npoints/4,1)=1;
    [posi_all(:,npoints/4+1:npoints/8*3,:)] = sub_cp(xmin,xmax/2,ymax/2,ymax,zmin,zmax/2,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/4+1:npoints/8*3,1)=1;
    [posi_all(:,npoints/8*3+1:npoints/2,:)] = sub_cp(xmax/2,xmax,ymax/2,ymax,zmin,zmax/2,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/8*3+1:npoints/2,1)=1;
    [posi_all(:,npoints/2+1:npoints/8*5,:)] = sub_cp(xmin,xmax/2,ymin,ymax/2,zmax/2,zmax,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/2+1:npoints/8*5,1)=1;
    [posi_all(:,npoints/8*5+1:npoints/4*3,:)] = sub_cp(xmax/2,xmax,ymin,ymax/2,zmin,zmax,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/8*5+1:npoints/4*3,1)=1;
    [posi_all(:,npoints/4*3+1:npoints/8*7,:)] = sub_cp(xmin,xmax/2,ymax/2,ymax,zmax/2,zmax,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/4*3+1:npoints/8*7,1)=1;
    [posi_all(:,npoints/8*7+1:npoints,:)] = sub_cp(xmax/2,xmax,ymax/2,ymax,zmax/2,zmax,npoints/8,num_m,min_distance,v_min,v_max);idx(npoints/8*7+1:npoints,1)=1;
end



end


