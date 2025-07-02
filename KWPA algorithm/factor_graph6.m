classdef factor_graph6 < handle
    %%%%%%%%%高斯牛顿+直接分解（QR）&&&&&&&&&&&&&&&&&&&&
%建立分布式因子图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%factor_type : 0-本机先验因子；1-其他节点先验因子；2-测距因子；
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        A = [];    %全局雅可比矩阵
        d = [];    %全局残差向量
        delta_X;   %状态更新向量
        x_num      = 1;     %当前时刻状态点总数
        parameters = [];   %记录所有时刻的状态值      注意：这里位置的单位应该是m
        para_list  = [];   %分四列：factor_type；量测数；节点号；残差向量所在第一行
        P_covariance;      %记录当前时刻的协方差
        d_row;%残差的行数
        P_all;%全部协方差        
        distance = [];%距离信息
        imu_data;         % 存储IMU数据的属性
        imu_jacobian;     % 存储IMU雅可比矩阵的属性
    end

    methods
        function obj = factor_graph6(x,Xerr)     %以初始时刻的先验信息初始化，有个先验因子
            
            obj.para_list = [0,3,1,1];   %先验因子
            Jaco_prior    = eye(3,3);
            Xerr0         = Xerr;
            PK            = diag((Xerr0.^2));
            
            sqrt_info     = chol(inv(PK));
            
            obj.A         = sqrt_info * Jaco_prior;
            
            obj.parameters = [obj.parameters;x];
            obj.d = zeros(3,1);
            obj.d_row = 3;    %表示残差向量已存在3行
        end
        %%添加相连的无人机位置因子
       function para_add(obj,x,Xerr,k)
            obj.x_num = obj.x_num + 1;
            obj.para_list = [obj.para_list;
                             1,3,k,obj.d_row+1];   %
            obj.parameters = [obj.parameters;x];
            Jaco_prior    = eye(3,3);
            Xerr0         = Xerr;
            PK            = diag((Xerr0.^2));
            
            sqrt_info     = chol(inv(PK));
            [m1,n1] = size(obj.A);%获取矩阵A的行列数
            H = sqrt_info * Jaco_prior;
            obj.A = [obj.A,zeros(m1,3);
                     zeros(3,n1),H];
            
            obj.d = [obj.d;zeros(3,1)];
            obj.d_row = obj.d_row + 3;
       end 
       %%添加测距因子
         function factor_add(obj,J,b,k1,dis) %b是残差
           %J是上一步测得的残差雅可比矩阵
             obj.d = [obj.d;b];
            [m1,n1] = size(obj.A);     
            m2 = size(b,1);%获取b矩阵的行
            J1 = J(1,1:3); J2 = J(1,4:6);
            obj.A = [obj.A;
                     J1,zeros(1,(k1-2)*3),J2,zeros(1,n1-k1*3)];

            obj.para_list = [obj.para_list;
                             2,m2,k1,obj.d_row + 1];
            obj.d_row = obj.d_row + 1;
            obj.distance = [obj.distance dis];
         end
 
        %%状态点替换
             function para_replace(obj,x,Xerr,k)%%k指连接到的无人机个数
            for i = 1:size(obj.para_list,1)%%行
                if obj.para_list(i,1) == 1 && obj.para_list(i,3) == k%%找到满足条件的条目，即第一列为1且第三列等于k的行
                    obj.parameters((k-1)*3+1:(k-1)*3+3,1) = x;%%第k个参数替换为输入值x
                    Jaco_prior    = eye(3,3);
                    Xerr0         = Xerr;
                    PK            = diag((Xerr0.^2));
            
                    sqrt_info     = chol(inv(PK));

                    H = sqrt_info * Jaco_prior;
                    
                    row = obj.para_list(i,4);
                    obj.A(row:row+2,(k-1)*3+1:(k-1)*3+3) = H;%%H矩阵赋值给对象obj的A
                    obj.d(row:row+2,1) = zeros(3,1);%%零向量赋值给d，d列向量
                    break
                end
            end
        end
        %%factor_replace()：替换已有的测距因子
        function factor_replace(obj,J,b,k1)
            for i = 1:size(obj.para_list,1)
                if obj.para_list(i,1) == 2 && obj.para_list(i,3) == k1%%查找属性值为 2（表示该参数为测距因子）且属性序号为 k1 的行
                    row = obj.para_list(i,4);
                    J1 = J(1,1:3); J2 = J(1,4:6);%%矩阵 J 分别按照位置拆分为前三列和后三列的 1*3 矩阵
                    [m1,n1] = size(obj.A);%%计算参数矩阵 A 的列数，并将其保存在 n1 变量中
                    obj.A(row,:) = [J1,zeros(1,(k1-2)*3),J2,zeros(1,n1-k1*3)];%%;%%J是1*6矩阵，前三个元素J1和后三个元素J2分别被用来更新参数矩阵obj.A中第row行的列
                    
                    obj.d(row,1) = b;
                    
                    break
                end
            end
        end

       
       %高斯牛顿
       function GN(obj,posi_1,Xerr)
      
     n_iters = 50;%%最大迭代次数
            thresh  = 1e-5;%%迭代停止阈值
            for i = 1:n_iters
                [Q,R] = qr(obj.A);%%雅可比矩阵A进行QR分解
                obj.delta_X = - R \ Q' * obj.d;     %注意：这里加负号,表示参数增量是当前参数值和最优参数值之间的差%%状态量的更新量，在每次迭代中都会被更新
                %obj.delta_X=-(obj.A'*obj.A)\obj.A'*obj.d;
                [obj.parameters] = graph_modi1(obj.parameters,obj.delta_X);%%使用graph_modi()函数更新状态量。
                k = 1;
                for a = 1:size(obj.para_list,1)                     %
                    switch obj.para_list(a,1)
                       case 0              %代表本机先验因子
                           Xerr0         = Xerr;
                           PK            = diag((Xerr0.^2));
%                            Jaco_prior    = eye(3,3); 
            
                           sqrt_info     = chol(inv(PK));
                           obj.d(1:3,1)    = sqrt_info * (obj.parameters(1:3,1) - posi_1);%%obj.parameters(1:3,1)表示当前状态估计值中第一个点的坐标，posi_1表示本机的位置估计值
%                            obj.A(1:3,1:3) = sqrt_info * Jaco_prior;将雅可比矩阵的前三行设置为本机先验因子的雅可比矩阵
                           k = k +3;
                       case 1      %代表其他节点先验因子
                           %不用进行更新
                           %%
                           
                           %%                           
                           k = k + 3;
                       case 2%%测距因子
                           k1 = obj.para_list(a,3);%%获取与当前测距因子相关联的点的编号
                           
                           Pi = obj.parameters(1:3,1);%%获取当前状态估计值中第一个点的坐标
                           Pj = obj.parameters((k1-1)*3 + 1 : (k1-1)*3 + 3 , 1);%%获取与当前测距因子相关联的另一个点的坐标
                           %%计算观测残差
                           [residual,jaco] = residual_cal(Pi,Pj,obj.distance(1,k1-1));
                           
                           obj.d(obj.para_list(a,4),1) = residual;
                           
                           J1 = jaco(1,1:3); J2 = jaco(1,4:6); n1 = size(obj.A,2);%%构造A矩阵，存储所有状态量对应的Jacobian矩阵
                           obj.A(obj.para_list(a,4),:) = [J1,zeros(1,(k1-2)*3),J2,zeros(1,n1 - k1*3)];
                           
                           k = k + 1;%%将当前状态变量编号加一，为下一个状态变量做准备
                         
                           
                    
                end
                
          
                end 
                if max(obj.delta_X(1:3,1)) < thresh%%若状态更新量最大值小于停止阈值，则高斯-牛顿法迭代结束
                    break
                end
      
 end
 end
  function covariance(obj)%%covariance()：计算协方差矩阵
                
                P_info  =  obj.A' * obj.A;
                P_covariance_sum = (inv(P_info));
                obj.P_covariance = P_covariance_sum(1:3,1:3);
                obj.P_all = P_covariance_sum;%%所有状态量的协方差矩阵
       
        

    end
end
end