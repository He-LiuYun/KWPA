function [residuals,jaco] = residual_cal(posi_1,posi_2,d)
%测距因子的残差：计算节点之间的残差和雅可比矩阵
%注意：这里的posi需要是以m为单位
H = zeros(1,6);
r = sqrt((posi_1 - posi_2)' * (posi_1 - posi_2));%%欧氏距离
H(1,1) =   (posi_1(1,1) - posi_2(1,1))/r;
H(1,2) =   (posi_1(2,1) - posi_2(2,1))/r;
H(1,3) =   (posi_1(3,1) - posi_2(3,1))/r;
H(1,4) = - (posi_1(1,1) - posi_2(1,1))/r;
H(1,5) = - (posi_1(2,1) - posi_2(2,1))/r;
H(1,6) = - (posi_1(3,1) - posi_2(3,1))/r;%%根据公式计算了雅可比矩阵H的各个元素，并将其存储在H中

residuals = r - d;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
residuals = 1/sqrt(0.09) * residuals;      %乘以误差矩阵的平方根

jaco = 1/sqrt(0.09) * H;

end