function [fun_value,num_FVB,fun_value_best]=FV(GROUP,cons,num_p,num_t,posi_GPS_all,npoints,dis_measure,dis_err)

%根据分组重新生成子无向图
subNoDirectionmatrix=zeros(npoints,npoints,num_p);
fun_value=zeros(num_p,1);
for q=1:num_p
    if cons(q,1)==2  
         %生成子无向图
         subNoDirectionmatrix(:,:,q)=SNDM(GROUP(:,:,q),npoints,num_t); 
         %计算评价函数
         fun_value(q,1)=FV_detail(subNoDirectionmatrix(:,:,q),posi_GPS_all,npoints,dis_measure,dis_err);
    else
         fun_value(q,1)=cons(q,1);
    end
end
%Alpha 的信息
[fun_value_best,num_FVB]=max(fun_value(1:num_p,1),[],1 );%获取（约束条件+适应度）最大值

end

