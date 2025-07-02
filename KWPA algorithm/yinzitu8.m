%%基于GA+GNCG的因子图优化算法
% uav_num    : 所有无人机的数目
% posi_L_all ：锚机的位置
% posi_W_all ：子机的位置
% Xerr_num   ：所有子机位置的协方差的对角线元素的平方根
% posi_WGPS_all ：子机的GNSS位置
% posi_LGPS_all ：锚机的GNSS位置
% posi_w_graph_i ： 所有子机图优化后的位置
% Xerr_gps_low ： 低精度GNSS误差标准差
% Xerr_gps_high： 高精度GNSS误差标准差
%posi_Wi_1第i个无人机第一时刻的位置，posi_Wi_2第i个无人机第二个时刻的位置
% uav_link_num ：记录每个子机相连接的其他无人机的编号
function GN_posi = yinzitu8(posi_GPS_all,dis_measure,Xerr_gps_low)

num_h=0;%高精度节点数量


num_l=size(posi_GPS_all,2)-num_h;
posi_LGPS_all=posi_GPS_all(:,1:num_l);
posi_HGPS_all=posi_GPS_all(:,num_l+1:num_l+num_h);


    %%%%%%%连接无人机%%%%%%%%%%%%%%%%%
    k_num = zeros(num_l,1);
    for i = 1:num_l
        uav_link_num{1,i} = [];   %记录每个辅机相连接的无人机标号
        uav_link_num1{1,i} = [];
    end
    %%传感器配置建模
    dis_err = 0.2; %设置测距误差标准差为0.2m
    
    
  
    %%存储GPS
    GPSposi=zeros(1,3*num_l);
    for a=1:num_l
        GPSposi(1,(3*a-2):(3*a))=posi_LGPS_all(:,a)';
    end

 
    %%误差协方差
    %Xerr_gps_low = [5;5;5]; 
    Xerr_gps_high = [0.1;0.1;0.1];

 
 

GNposi=zeros(1,3*num_l);



    %%%%%%%%%%%%%%%gaosiniud%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%GN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  graph_array=cell(1,num_l);

    graph_1  = factor_graph6(posi_LGPS_all(:,1),Xerr_gps_low);
    graph_array{1} = graph_1;
  

    graph_2  = factor_graph6(posi_LGPS_all(:,2),Xerr_gps_low);
    graph_array{2} = graph_2;
   

    graph_3  = factor_graph6(posi_LGPS_all(:,3),Xerr_gps_low);
    graph_array{3} = graph_3;
 

    graph_4  = factor_graph6(posi_LGPS_all(:,4),Xerr_gps_low);
    graph_array{4} = graph_4;
  

    graph_5  = factor_graph6(posi_LGPS_all(:,5),Xerr_gps_low);
    graph_array{5} = graph_5;
 

    graph_6  = factor_graph6(posi_LGPS_all(:,6),Xerr_gps_low);
    graph_array{6} = graph_6;


    graph_7  = factor_graph6(posi_LGPS_all(:,7),Xerr_gps_low);
    graph_array{7} = graph_7;
 

    graph_8  = factor_graph6(posi_LGPS_all(:,8),Xerr_gps_low);
    graph_array{8} = graph_8;

   
for i =1:num_l
        k_num(i,1) = k_num(i,1) + 1;  %所有图中都加入了初始因子
end

%%开始加入各个因子，加入锚机
for i = 1:num_l
    for j = 1:num_h
        k_num(i,1) = k_num(i,1) + 1;
        
        graph_array{i}.para_add(posi_HGPS_all(:,j), Xerr_gps_high, k_num(i,1));
        [residual_1, jaco_1] = residual_cal(posi_LGPS_all(:,i), posi_HGPS_all(:,j), dis_measure(i,j+num_l));
        graph_array{i}.factor_add(jaco_1, residual_1, k_num(i,1), dis_measure(i,j+num_l));
        uav_link_num{1,i} = [uav_link_num{1,i}, j+num_l];
    end
end

Xerr_num = []; 
posi_iter_num =posi_LGPS_all;
 for i = 1:num_l
Xerr_num = [Xerr_num Xerr_gps_low];
 end



 %%%迭代
n_iters=1;
 

for n=1:n_iters
 if n== 1 
 for i = 1:num_l
    for j = 1:num_l
        if i ~= j
            k_num(i,1) = k_num(i,1) + 1;
            
            graph_array{i}.para_add(posi_LGPS_all(:,j), Xerr_num(:,j), k_num(i,1)); % 添加新的变量节点
            [residual_1, jaco_1] = residual_cal(posi_LGPS_all(:,i), posi_LGPS_all(:,j), dis_measure(i,j)); % 计算残差和雅可比矩阵
            graph_array{i}.factor_add(jaco_1, residual_1, k_num(i,1), dis_measure(i,j)); % 添加新的因子节点
            uav_link_num{1,i} = [uav_link_num{1,i}, j]; % 记录辅机标号
        end
    end
end



   else    %进行节点迭代替换

           k_num = ones(num_l,1);
            %辅机1：替换%%将其位置向量和GPS定位误差向量更新到迭代位置向量 posi_iter_num 中，并替换原有的因子
            for i = 1:num_l%%uav_link_num 的列数，与锚机1相连的辅机节点
                for k = 1:size(uav_link_num{1,i},2)
                 if uav_link_num{1, i}(1, k)>num_l
        % 如果是锚机，不进行替换操作，只增加k_num的值
                   k_num(i, 1) = k_num(i, 1) + 1;
        % 如果是锚机，不进行替换操作
                 else
                     k_num(i, 1) = k_num(i, 1) + 1;
                    graph_array{i}.para_replace(posi_iter_num(:,uav_link_num{1,i}(1,k)),Xerr_num(:,uav_link_num{1,i}(1,k)),k_num(i,1));%%将当前节点的位置向量和GPS定位误差向量替换到因子图 graph_1 中对应的变量节点中
                    [residual_1,jaco_1] = residual_cal(posi_iter_num(:,i),posi_iter_num(:,uav_link_num{1,i}(1,k)),dis_measure(1,uav_link_num{1,i}(1,k)));%%(:,uav_link_num{1,1}(1,i)) 是该节点的位置向量
                    graph_array{i}.factor_replace(jaco_1,residual_1,k_num(i,1));%%替换为新的因子
                 end
                end
            end
 end

 %使用高斯牛顿进行寻找最优解

     graph_1.GN(posi_LGPS_all(:,1),Xerr_gps_low);
 
    graph_2.GN(posi_LGPS_all(:,2),Xerr_gps_low);
 
    graph_3.GN(posi_LGPS_all(:,3),Xerr_gps_low);
 
    graph_4.GN(posi_LGPS_all(:,4),Xerr_gps_low);
 
    graph_5.GN(posi_LGPS_all(:,5),Xerr_gps_low);
 
    graph_6.GN(posi_LGPS_all(:,6),Xerr_gps_low);
 
    graph_7.GN(posi_LGPS_all(:,7),Xerr_gps_low);
 
    graph_8.GN(posi_LGPS_all(:,8),Xerr_gps_low);

   

    graph_1.covariance();
    P = [graph_1.P_covariance(1,1);graph_1.P_covariance(2,2);graph_1.P_covariance(3,3)];
    Xerr_num(:,1) = sqrt(P);
  
    graph_2.covariance();
    P = [graph_2.P_covariance(1,1);graph_2.P_covariance(2,2);graph_2.P_covariance(3,3)];
    Xerr_num(:,2) = sqrt(P);
  
     graph_3.covariance();
     P = [graph_3.P_covariance(1,1);graph_3.P_covariance(2,2);graph_3.P_covariance(3,3)];
     Xerr_num(:,3) = sqrt(P);
        
    graph_4.covariance();
    P = [graph_4.P_covariance(1,1);graph_4.P_covariance(2,2);graph_4.P_covariance(3,3)];
    Xerr_num(:,4) = sqrt(P);
  
     graph_5.covariance();
     P = [graph_5.P_covariance(1,1);graph_5.P_covariance(2,2);graph_5.P_covariance(3,3)];
     Xerr_num(:,5) = sqrt(P);
   
    graph_6.covariance();
    P = [graph_6.P_covariance(1,1);graph_6.P_covariance(2,2);graph_6.P_covariance(3,3)];
    Xerr_num(:,6) = sqrt(P);
  
    graph_7.covariance();
    P = [graph_7.P_covariance(1,1);graph_7.P_covariance(2,2);graph_7.P_covariance(3,3)];
    Xerr_num(:,7) = sqrt(P);
  
     graph_8.covariance();
     P = [graph_8.P_covariance(1,1);graph_8.P_covariance(2,2);graph_8.P_covariance(3,3)];
     Xerr_num(:,8) = sqrt(P);

        

 if max(abs(graph_1.parameters(1:3,1) - posi_iter_num(:,1))) < 0.001 && max(abs(graph_2.parameters(1:3,1) - posi_iter_num(:,2))) < 0.001 ...
                && max(abs(graph_3.parameters(1:3,1) - posi_iter_num(:,3))) < 0.001&& max(abs(graph_4.parameters(1:3,1) - posi_iter_num(:,4))) < 0.001 ...
                && max(abs(graph_5.parameters(1:3,1) - posi_iter_num(:,5))) < 0.001&& max(abs(graph_6.parameters(1:3,1) - posi_iter_num(:,6))) < 0.001 ...
                && max(abs(graph_7.parameters(1:3,1) - posi_iter_num(:,7))) < 0.001&& max(abs(graph_8.parameters(1:3,1) - posi_iter_num(:,8))) < 0.001
            break
 else
            posi_iter_num(:,1)  = graph_1.parameters(1:3,1); posi_iter_num(:,2)  = graph_2.parameters(1:3,1); posi_iter_num(:,3) = graph_3.parameters(1:3,1);
            posi_iter_num(:,4)  = graph_4.parameters(1:3,1); posi_iter_num(:,5)  = graph_5.parameters(1:3,1); posi_iter_num(:,6) = graph_6.parameters(1:3,1);
            posi_iter_num(:,7)  = graph_7.parameters(1:3,1); posi_iter_num(:,8)  = graph_8.parameters(1:3,1);
           
 end
       
           
 
end


    GNposi(1,1:3)=graph_1.parameters(1:3,1)';

    GNposi(1,4:6)=graph_2.parameters(1:3,1)';

    GNposi(1,7:9)=graph_3.parameters(1:3,1)';

   GNposi(1,10:12)=graph_4.parameters(1:3,1)';

     GNposi(1,13:15)=graph_5.parameters(1:3,1)';

    GNposi(1,16:18)=graph_6.parameters(1:3,1)';

    GNposi(1,19:21)=graph_7.parameters(1:3,1)';

     GNposi(1,22:24)=graph_8.parameters(1:3,1)';


for i=1:num_l
    GN_posi(:,i)=GNposi(1,3*i-2:3*i);
    
end

