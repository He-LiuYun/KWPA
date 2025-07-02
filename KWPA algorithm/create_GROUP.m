function [GROUP]=create_GROUP(Group,npoints,num_p,dex_NoOneTeam)
%CREATE_GROUP 此处显示有关此函数的摘要

parfor q=1:num_p
    GROUP(:,:,q)=procho_One(Group,npoints,dex_NoOneTeam);
end

end

