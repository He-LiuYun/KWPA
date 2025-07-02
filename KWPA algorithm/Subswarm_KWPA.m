function [subswarm_numt,subswarm_res_GROUP] = Subswarm_KWPA(posi_GPS_all,threshold,num_p,max_iter,dis_err,dis_measure)

%生成邻接矩阵(无向图)
[NoDirectionmatrix,npoints] = nodire(posi_GPS_all,threshold);


%子编队节点数范围
sub_rang=[5,8];  
%由于每个编队个无人机节点数量是5~8个，所以编队最多有npoints/5（向上取整）个，最少有npoints/8（向上取整）个。
maxK=ceil(npoints/sub_rang(1));minK=ceil(npoints/sub_rang(2));%最大编队数和最小编队数
T=maxK-minK+1;    %子编队数量的情况数量



fun_value=cell(T,1);
Group=cell(T,1);
GROUP=cell(T,1);
cons=cell(T,1);
dex_NoOneTeam=cell(T,1);
Tge_fVB=zeros(T,1);
dex_FVB=zeros(T,1);


%迭代步长   Sa,Sb,Sc;
[Sa,Sb,Sc,Nonew] = iter_Step(npoints);
Pv=0.5;%变异阈值


parfor t=1:T
    num_t=minK+t-1;
    %聚类数量即初始编队的数量
    %类表矩阵和多子编队节点编号
    [Group{t},dex_NoOneTeam{t}]=kmeans_plus(num_t, posi_GPS_all,threshold,sub_rang(1));
    GROUP{t}=create_GROUP(Group{t},npoints,num_p,dex_NoOneTeam{t});
    cons{t}=constraint(GROUP{t},NoDirectionmatrix,num_t,num_p,sub_rang);
end


iter=0;
condition_break=false;

%WPA
while iter<=max_iter&&condition_break==false
    iter=iter+1; 
    parfor t=1:T
        num_t=minK+t-1;
        [fun_value{t},dex_FVB(t,1),Tge_fVB(t,1)]=FV(GROUP{t},cons{t},num_p,num_t,posi_GPS_all,npoints,dis_measure,dis_err);
    end
    %汇总T个子编队数量的最优分组结果的目标函数值
    Tge_fVB_best(iter,1)=max(Tge_fVB);
    %提前跳出
    if iter>=Nonew
        %Nonew次未更新
        if (isempty(setdiff(Tge_fVB_best(iter-Nonew+1:iter-1),Tge_fVB_best(iter,1)))||iter==max_iter)&&Tge_fVB_best(iter,1)>2
            condition_break=true;
        end
    end
    if condition_break==false
        parfor t=1:T
            num_t=minK+t-1;
            %迭代
            %靠近操作
            GROUP{t}=mutate(cons{t},Sa,Sb,GROUP{t},dex_FVB(t,1),num_p,dex_NoOneTeam{t});
            %变异操作
            GROUP{t}=Var(cons{t},Sc,GROUP{t},Pv,Group{t},iter,max_iter,num_p,dex_NoOneTeam{t},dex_FVB(t,1)); 
            cons{t}=constraint(GROUP{t},NoDirectionmatrix,num_t,num_p,sub_rang);
            %引入新个体
            if Tge_fVB_best(iter,1)<2
                new_dex=find(cons{t}<2);
                mid_dex=ceil(length(new_dex)/2);
                GROUP{t}(:,:,new_dex(1:mid_dex))=create_GROUP(Group{t},npoints,mid_dex,dex_NoOneTeam{t});
                for q=mid_dex+1:length(new_dex)
                    GROUP{t}(:,:,new_dex(q))=rand_cho_One(Group{t},npoints);    
                end
                cons{t}(new_dex,1)=constraint(GROUP{t}(:,:,new_dex),NoDirectionmatrix,num_t,length(new_dex),sub_rang);
            end
        end
    end
end

%所有子编队数量，选取评价函数最优值 以20节点举例，选取3、4个子编队两种分组结果中评价函数值最优值
[res_FV_best,FV_best]=max(Tge_fVB(1:T,1),[],1 );%获取（约束条件+适应度）最大值
subswarm_res_GROUP=GROUP{FV_best}(:,:,dex_FVB(FV_best,1));
subswarm_numt=FV_best+minK-1;

end

