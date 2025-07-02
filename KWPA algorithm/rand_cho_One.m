function matrix = rand_cho_One(matrix,npoints)  
        
for j=1:npoints
    indices = find(matrix(:,j) == 1); 
    matrix(:,j) = zeros(size(matrix(:,j),1),1); % 先将所有1置0  
    len=size(indices,1);
    i=randi([1,len]);
    matrix(indices(i),j) = 1; % 再将第i个置1  
end

end