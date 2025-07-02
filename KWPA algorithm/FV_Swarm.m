function fun_value=FV_Swarm(subNoDirectionmatrix,posi_GPS_all,npoints,dis_measure,dis_err)

%评价函数
JFisher=zeros(3*npoints,3*npoints);

for i=1:npoints%低精度节点循环
    for j=1:npoints%对于所有节点
        if subNoDirectionmatrix(i,j)==1
            dis_measure_square=dis_measure(i,j)^2;
            JFisher(3*(i-1)+1,3*(i-1)+1)=JFisher(3*(i-1)+1,3*(i-1)+1)+(posi_GPS_all(1,i)-posi_GPS_all(1,j))^2/dis_measure_square;
            JFisher(3*(i-1)+1,3*(i-1)+2)=JFisher(3*(i-1)+1,3*(i-1)+2)+((posi_GPS_all(1,i)-posi_GPS_all(1,j))*(posi_GPS_all(2,i)-posi_GPS_all(2,j)))/dis_measure_square;
            JFisher(3*(i-1)+1,3*(i-1)+3)=JFisher(3*(i-1)+1,3*(i-1)+3)+((posi_GPS_all(1,i)-posi_GPS_all(1,j))*(posi_GPS_all(3,i)-posi_GPS_all(3,j)))/dis_measure_square;
                         
            JFisher(3*(i-1)+2,3*(i-1)+2)=JFisher(3*(i-1)+2,3*(i-1)+2)+(posi_GPS_all(2,i)-posi_GPS_all(2,j))^2/dis_measure_square;
            JFisher(3*(i-1)+2,3*(i-1)+3)=JFisher(3*(i-1)+2,3*(i-1)+3)+((posi_GPS_all(2,i)-posi_GPS_all(2,j))*(posi_GPS_all(3,i)-posi_GPS_all(3,j)))/dis_measure_square;
                         
                         
            JFisher(3*(i-1)+3,3*(i-1)+3)=JFisher(3*(i-1)+3,3*(i-1)+3)+(posi_GPS_all(3,i)-posi_GPS_all(3,j))^2/dis_measure_square;
         end
     end
     JFisher(3*(i-1)+2,3*(i-1)+1)=JFisher(3*(i-1)+1,3*(i-1)+2);
     JFisher(3*(i-1)+3,3*(i-1)+1)=JFisher(3*(i-1)+1,3*(i-1)+3);
     JFisher(3*(i-1)+3,3*(i-1)+2)=JFisher(3*(i-1)+2,3*(i-1)+3);
                    
     dett(i,i)=det((JFisher(3*(i-1)+1:3*(i-1)+3,3*(i-1)+1:3*(i-1)+3)/dis_err^2));
end
fun_value=norm(dett(:,:),2); 
        

end

