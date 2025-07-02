clear;
% number of nodes in the simulation verification
% 20、30、50、100、200、400、800、1000  
npoints =50; % the number of nodes




num_m=100;
[posi_all,posi_GPS_all,GN_posi,RMSE,res_GROUP,fun_value,time] = run(npoints,num_m);



%display the average value of the objective function
disp(['the average value of the objective function:  ', num2str(sum(fun_value)/num_m)]);
% display E
disp(['the average localization estimation error  :  ', num2str(sum(RMSE)/npoints), 'm']);
% display the average execution time
disp(['average time:  ', num2str(sum(time)/num_m), 's']);

