%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   计算两点的距离
%   输入：A点位置
%         B点位置
%
%   输出：AB两点距离
%
%                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Dis] = DistanceAB(pointA,pointB)

%   Dis = sqrt(pointA'*pointB);
  
  VectorDis = pointA - pointB;
  Dis = sqrt(VectorDis'*VectorDis);

end
