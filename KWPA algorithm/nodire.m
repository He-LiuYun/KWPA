%根据UWB测距，生成无向图
function [NoDirectionmatrix,npoints] = nodire(posi_all,threshold)
 % 计算距离并更新连接矩阵
    npoints=size(posi_all,2);
    NoDirectionmatrix=zeros(npoints,npoints);
    for i = 1:npoints
        for j = i+1:npoints
            dist =  DistanceAB(posi_all(:,i),posi_all(:,j)); % 计算点之间的欧氏距离
            if dist < threshold
               NoDirectionmatrix(i, j) = 1;
               NoDirectionmatrix(j, i) = 1;
            end
        end
    end
end



