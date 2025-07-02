function [dis_measure,dis_true] = simu_dis(posi_all,err,num_m)
%计算载体之间的距离
npoints = size(posi_all(:,:,1),2);   %获取矩阵的列数

dis_true = zeros(npoints,npoints,num_m);
dis_measure = zeros(npoints,npoints,num_m);
for q=1:num_m
    for i = 1:npoints
        for j = 1:npoints
            if i~=j
                dis_true(i,j,q) = DistanceAB(posi_all(:,i,q),posi_all(:,j,q));
                dis_measure(i,j,q) = dis_true(i,j,q) + err*randn(1,1);%添加测距误差
            end
        end
    end
end