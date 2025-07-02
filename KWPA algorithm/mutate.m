function GROUP=mutate(cons,Sa,Sb,GROUP,num_FVB,num_p,dex_NoOneTeam)   %以步长Sa靠近α狼 以步长Sb靠近α狼

for q=1:num_p
    if cons(q,1)==2&&q~=num_FVB
        if length(dex_NoOneTeam)>=Sa
            selected_beita_idx = randperm(length(dex_NoOneTeam), Sa);
            GROUP(:,dex_NoOneTeam(selected_beita_idx),q)=GROUP(:,dex_NoOneTeam(selected_beita_idx),num_FVB);
        elseif length(dex_NoOneTeam)<Sa&&~isempty(dex_NoOneTeam)
            GROUP(:,dex_NoOneTeam,q)=GROUP(:,dex_NoOneTeam,num_FVB);
        end
    elseif cons(q,1)<2
        if length(dex_NoOneTeam)>=Sb
            selected_gama_idx = randperm(length(dex_NoOneTeam), Sb);
            GROUP(:,dex_NoOneTeam(selected_gama_idx),q)=GROUP(:,dex_NoOneTeam(selected_gama_idx),num_FVB);
        elseif length(dex_NoOneTeam)<Sb&&~isempty(dex_NoOneTeam)
            GROUP(:,dex_NoOneTeam,q)=GROUP(:,dex_NoOneTeam,num_FVB);
        end
    end


end

