function [posi_all,posi_GPS_all,GN_posi,RMSE,res_GROUP,fun_value,time] = run(npoints,num_m)



min_distance = 80; % 节点的最小安全距离 
threshold=500;
v_min=0;v_max=10;%运动速度

disp('initialization');
%生成节点运动轨迹
[posi_all,xmin,xmax,ymin,ymax,zmin,zmax] = point_move(npoints, min_distance, num_m, v_min, v_max);

%给定参数误差，由理论值，得到测量值
dis_err = 0.1;
%UWB
[Swarm_dis_measure,dis_true] = simu_dis(posi_all,dis_err,num_m);   
%GPS误差协方
Xerr_gps  = [5;5;5];
%GPS位置信息
posi_GPS_all = simu_gps(posi_all,Xerr_gps,num_m);
   
max_iter=100; %最大迭代次数
num_p=100;%种群数量

fun_value=zeros(1,num_m);       %fun_value      评价函数值
res_GROUP=cell(num_m,1);        %res_GROUP      分组结果
GN_posi=zeros(3,npoints,num_m); %GN_posi        协同定位后的节点位置
time=zeros(1,num_m);            %time           运行时间

disp('start running');
for r=1:num_m
    [fun_value(1,r),res_GROUP{r},GN_posi(:,:,r),time(1,r)]=...
    KWPA(npoints,posi_GPS_all(:,:,r),num_p,max_iter,dis_err,Swarm_dis_measure(:,:,r),Xerr_gps,xmin,xmax,ymin,ymax,zmin,zmax,threshold);
end
   

RMSE=RMSE_F(npoints,GN_posi,posi_all,num_m);
end

