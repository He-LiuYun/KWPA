function [Group,dex_NoOneTeam] = kmeans_plus(num_t, posi_GPS_all,threshold,sub_rangmin)

[~, C] = kmeans(posi_GPS_all', num_t, 'Start', 'plus');  % kmeans期望输入是列向量
C=C';
max_iter=100;
npoints=size(posi_GPS_all,2);
Group=zeros(3,npoints,max_iter);
for iter=1:max_iter
     %改进K-means
     Group=zeros(num_t,npoints);
     % 按照设定分配数据点
     for i=1:npoints
         for j=1:num_t
             dist= DistanceAB(posi_GPS_all(:,i),C(:,j));
             if dist<=0.5*threshold
                 Group(j,i)=1;
             elseif  dist>=threshold
                 Group(j,i)=0;
             else
                  if rand()<(threshold-dist)/threshold
                      Group(j,i)=1;
                  else
                      Group(j,i)=0;
                  end
             end
         end
     end
     %孤立结点分配最近聚类中心节点
     for k=1:npoints
         if sum(Group(:,k))==0
            dist_zqzx=zeros(1,num_t);
            for t=1:num_t
                dist_zqzx(1,t)=DistanceAB(posi_GPS_all(:,k),C(:,t));
            end
            [~, minIndex] = min(dist_zqzx);
            Group(minIndex,k)=1;
         end
     end 
    if all(sum(Group(:,:), 2)>=sub_rangmin)
        break;
    end
end

dex_NoOneTeam=find(sum(Group,1)>1);

end
