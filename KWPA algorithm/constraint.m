function cons=constraint(GROUP,NoDirectionmatrix,num_t,num_p,sub_rang)

% GROUP: 3D矩阵 (num_t × npoints × num_p)，表示每个样本的子编队分组情况
% NoDirectionmatrix: npoints × npoints 的邻接矩阵，表示点间是否可以通信（对称矩阵）
% num_t: 每个样本的子编队个数
% num_p: 样本个数
% sub_rang: 子编队大小约束范围 [min,max]



for q = 1:num_p
    group_q=GROUP(:,:,q);
    %约束1：每个子编队的节点数在 [5,8] 范围内
    team_sizes = sum(group_q, 2);  % 每个子编队包含的节点数（按行求和）
    if all(team_sizes >= sub_rang(1)) && all(team_sizes <= sub_rang(2))
        con1 = 1;
    else
        con1=0;
    end

   

    %约束2：每个子编队内节点可两两互相通信（即构成完全子图）
    if con1==1
        con2 = 1;
        for k = 1:num_t
            members = find(group_q(k,:) == 1);
            if length(members) > 1
                subgraph = NoDirectionmatrix(members, members);
                if ~isequal(subgraph, ones(length(members)) - eye(length(members)))
                    con2 = 0;  % 不是完全图
                    break;
                end
            end
        end
    else
        con2=0;
    end
    %约束3：每个节点只能属于一个子编队（按列求和应该等于1）
    
    cons(q,1)=con1+con2;

end


end
