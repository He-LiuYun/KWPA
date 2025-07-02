
%                   GPS仿真输出
%
%  
%  posi       航迹发生器对应的x、y、z（单位：米、米、米）
%   
%  err       GPS定位的误差err=[err1;err2;err3](分别为x,y,z方向的定位误差)
%
%              



function [posiG]=simu_gps(posi_all,Xerr_gps,num_m)
  npoints = size(posi_all(:,:,1),2);   %高精度个数%获取矩阵的列数
  for q=1:num_m
      for j=1:npoints
        Err = [Xerr_gps(1,1)*randn(1,1); Xerr_gps(2,1)*randn(1,1); Xerr_gps(3,1)*randn(1,1)];
        posiG(:,j,q) = posi_all(:,j,q) + Err;
      end
  end
end 
    
  