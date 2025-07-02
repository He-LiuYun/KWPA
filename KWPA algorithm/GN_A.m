function res_GN_posi=GN_A(res_GROUP,posi_GPS_all,dis_measure,Xerr_gps,tnum,npoints)

for k=1:7
     %按照分组进行高斯牛顿定位
     if k==1
         Alphaposi=posi_GPS_all;
     else
         Alphaposi=GN_posi(:,:,k-1);
     end
     for j=1:tnum%编队数
        onesIndices = find(res_GROUP(j,:) == 1);
        Alpha_posi=Alphaposi(:, onesIndices);
        % 计算元素的个数  
        count= size(onesIndices,2);
        sub_dis_measure=dis_measure(onesIndices,onesIndices);
        GN=zeros(3,count);
        if count==8
            GN = yinzitu8(Alpha_posi,sub_dis_measure,Xerr_gps);
        end
        if count==7
            GN = yinzitu7(Alpha_posi,sub_dis_measure,Xerr_gps);
        end
        if count==6
            GN = yinzitu6(Alpha_posi,sub_dis_measure,Xerr_gps);
        end
        if count==5
            GN = yinzitu5(Alpha_posi,sub_dis_measure,Xerr_gps);
        end
        for i=1:count
                GN_posi(:,onesIndices(1,i),k)=GN(:,i);
        end
     end
    Err=zeros(4,npoints);
    if k>1 
        Err(1:3,:)=GN_posi(:,:,k)-GN_posi(:,:,k-1);
        for i=1:npoints
            Err(4,i)=sqrt(Err(1,i)^2+Err(2,i)^2+Err(3,i)^2);
        end
        if max(Err(4,:))<0.1
            break;
        end
    end
    
      
end
res_GN_posi=GN_posi(:,:,k);

end


   


