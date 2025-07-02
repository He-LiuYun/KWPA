function [RMSE] =RMSE_F(npoints,GN_posi,posi_all,num_m)
RMSE_KWPA=cell(npoints,1); 
RMSE_KWPA_ENU=zeros(4,npoints);
for i=1:npoints
    for q=1:num_m
        RMSE_KWPA{i}(1:3,q)=GN_posi(:,i,q)-posi_all(:,i,q);
        RMSE_KWPA_ENU(1,i)=RMSE_KWPA_ENU(1,i)+RMSE_KWPA{i}(1,q)^2;
        RMSE_KWPA_ENU(2,i)=RMSE_KWPA_ENU(2,i)+RMSE_KWPA{i}(2,q)^2;
        RMSE_KWPA_ENU(3,i)=RMSE_KWPA_ENU(3,i)+RMSE_KWPA{i}(3,q)^2;

    end
    RMSE_KWPA_ENU(1,i)=sqrt(RMSE_KWPA_ENU(1,i)/num_m);
    RMSE_KWPA_ENU(2,i)=sqrt(RMSE_KWPA_ENU(2,i)/num_m);
    RMSE_KWPA_ENU(3,i)=sqrt(RMSE_KWPA_ENU(3,i)/num_m);
    RMSE_KWPA_ENU(4,i)=sqrt(RMSE_KWPA_ENU(1,i)^2+RMSE_KWPA_ENU(2,i)^2+RMSE_KWPA_ENU(3,i)^2);

end

RMSE=RMSE_KWPA_ENU(4,:);


end

