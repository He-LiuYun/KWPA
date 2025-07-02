function [res_FV_best,res_GROUP,GN_posi,time]=KWPA(Swarm_npoints,Swarm_posi_GPS_all,num_p,max_iter,dis_err,Swarm_dis_measure,Xerr_gps,xmin,xmax,ymin,ymax,zmin,zmax,threshold)





tic;
[SubSwarm_posi_GPS_all,SubSwarm_dis_measure,dex_subswarm,num_subswarm]=KJHF(Swarm_npoints,Swarm_posi_GPS_all,Swarm_dis_measure,xmin,xmax,ymin,ymax,zmin,zmax);
subswarm_res_GROUP=cell(num_subswarm,1);
subswarm_numt=zeros(num_subswarm,1);
parfor k=1:num_subswarm
   [subswarm_numt(k,1),subswarm_res_GROUP{k}]=Subswarm_KWPA(SubSwarm_posi_GPS_all{k},threshold,num_p,max_iter,dis_err,SubSwarm_dis_measure{k});
end
time=toc;



res_GROUP=zeros(sum(subswarm_numt),Swarm_npoints);
for k=1:num_subswarm
     res_GROUP(sum(subswarm_numt(1:k-1,1))+1:sum(subswarm_numt(1:k,1)),dex_subswarm{k})=subswarm_res_GROUP{k};
     GN_posi(:,dex_subswarm{k})=GN_A(subswarm_res_GROUP{k},SubSwarm_posi_GPS_all{k},SubSwarm_dis_measure{k},Xerr_gps,subswarm_numt(k,1),length(dex_subswarm{k}));
end
%合并子集群的分组结果得到大规模集群的分组结果，求解评价函数
subNoDirectionmatrix=SNDM(res_GROUP,Swarm_npoints,sum(subswarm_numt));

if constraint(res_GROUP,subNoDirectionmatrix,sum(subswarm_numt),1,[5,8])==2
    res_FV_best=FV_Swarm(subNoDirectionmatrix,Swarm_posi_GPS_all,Swarm_npoints,Swarm_dis_measure,dis_err);
else
    res_FV_best=0;
end

    

end


