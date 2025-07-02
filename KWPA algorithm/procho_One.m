function GROUP=procho_One(Group,npoints,dex_NoOneTeam)

GROUP=zeros(size(Group,1),npoints);
GROUP(:,setdiff(1:npoints,dex_NoOneTeam))=Group(:,setdiff(1:npoints,dex_NoOneTeam));
for i=1:length(dex_NoOneTeam)
    dex_t=find(Group(:,dex_NoOneTeam(i))==1);
    weights = 1 ./ ((sum(GROUP(dex_t,:),2)+1).^3);
    % 归一化概率权重，使总和为1
    probabilities = weights / sum(weights);
    selectedRow = randsample(1:length(dex_t), 1, true, probabilities);
    GROUP(dex_t(selectedRow),dex_NoOneTeam(i))=1;
end


end



