function [Sa,Sb,Sc,Nonew] = iter_Step(npoints)
    if npoints>=20&&npoints<30
        Sa=1;Sb=3;Sc=2;
    elseif npoints>=30&&npoints<50
        Sa=1;Sb=4;Sc=3;
    else
        Sa=1;Sb=5;Sc=4;
    end
    if npoints==20
        Nonew=15;
    elseif npoints>20&&npoints<=30
        Nonew=10;
    else
        Nonew=5;
    end
    
end

