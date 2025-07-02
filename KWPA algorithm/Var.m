function  GROUP=Var(cons,Sc,GROUP,Pv,Group,iter,max_iter,num_p,dex_NoOneTeam,num_FVB)    %变异操作

for q=1:num_p
    if cons(q,1)==2&&q~=num_FVB
        if iter/max_iter*rand()>Pv
            if length(dex_NoOneTeam)>=Sc
                selected_beita_idx = randperm(length(dex_NoOneTeam), Sc);
                GROUP(:,dex_NoOneTeam(selected_beita_idx),q)=rand_cho_One(Group(:,dex_NoOneTeam(selected_beita_idx))-GROUP(:,dex_NoOneTeam(selected_beita_idx),q),Sc);
            elseif length(dex_NoOneTeam)<Sc&&~isempty(dex_NoOneTeam)
                GROUP(:,dex_NoOneTeam,q)=rand_cho_One(Group(:,dex_NoOneTeam)-GROUP(:,dex_NoOneTeam,q),length(dex_NoOneTeam));
            end
        end
    elseif cons(q,1)<2
        if rand()>Pv
            if length(dex_NoOneTeam)>=Sc
                selected_gama_idx = randperm(length(dex_NoOneTeam), Sc);
                GROUP(:,dex_NoOneTeam(selected_gama_idx),q)=rand_cho_One(Group(:,dex_NoOneTeam(selected_gama_idx))-GROUP(:,dex_NoOneTeam(selected_gama_idx),q),Sc);
            elseif length(dex_NoOneTeam)<Sc&&~isempty(dex_NoOneTeam)
                GROUP(:,dex_NoOneTeam,q)=rand_cho_One(Group(:,dex_NoOneTeam)-GROUP(:,dex_NoOneTeam,q),length(dex_NoOneTeam));
            end
        end
    end




end



