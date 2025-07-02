function subNoDirectionmatrix=SNDM(GROUP,npoints,num_k)
subNoDirectionmatrix=zeros(npoints,npoints);
for k=1:num_k
    for i=1:npoints
        for j=i+1:npoints
            if  (GROUP(k,i)==1&&GROUP(k,j)==1)%两个节点在同一行就是在同一编队
                 subNoDirectionmatrix(i,j)=1;
                 subNoDirectionmatrix(j,i)=1;
            end
        end
    end
end

end

