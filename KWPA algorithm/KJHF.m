function [SubSwarm_posi_GPS_all,SubSwarm_dis_measure,idx_k,num_subswarm]=KJHF(Swarm_npoints,Swarm_posi_GPS_all,Swarm_dis_measure,xmin,xmax,ymin,ymax,zmin,zmax)

% 初始化
combin=[ceil((xmax-xmin)/500),ceil((ymax-ymin)/500),ceil((zmax-zmin)/400)];
num_subswarm=combin(1)*combin(2)*combin(3);
SubSwarm_posi_GPS_all = cell(num_subswarm, 1);
SubSwarm_dis_measure = cell(num_subswarm, 1);
idx_subswarm = zeros(Swarm_npoints, 1);  % 每个点的子集群编号

% 根据坐标为每个点分配子集群编号
for i = 1:Swarm_npoints
    x = Swarm_posi_GPS_all(1, i);
    y = Swarm_posi_GPS_all(2, i);
    z = Swarm_posi_GPS_all(3, i);

    % 区域编号（第几块）
    xi = ceil((x - xmin) / 500);
    yi = ceil((y - ymin) / 500);
    zi = ceil((z - zmin) / 400);
    
    % 限制范围
    xi = min(max(xi,1), combin(1));
    yi = min(max(yi,1), combin(2));
    zi = min(max(zi,1), combin(3));
    
    % 区域编号
    idx_subswarm(i) = sub2ind(combin, xi, yi, zi);  % 直接对应子集群编号
end

% 构造每个子集群的节点位置和距离测量矩阵
for k = 1:num_subswarm
    idx_k{k} = find(idx_subswarm == k);
    SubSwarm_posi_GPS_all{k} = Swarm_posi_GPS_all(:, idx_k{k});
    SubSwarm_dis_measure{k} = Swarm_dis_measure(idx_k{k}, idx_k{k});
end

end

