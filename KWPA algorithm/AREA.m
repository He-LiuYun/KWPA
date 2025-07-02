function [xmin,xmax,ymin,ymax,zmin,zmax]=AREA(npoints)


if npoints>=20&&npoints<30
    xmin = 0; xmax = 350; % x坐标的范围
    ymin = 0; ymax = 350; % y坐标的范围
    zmin = 0; zmax = 300; % z坐标的范围
elseif npoints==30&&npoints<50
    xmin = 0; xmax = 400; % x坐标的范围
    ymin = 0; ymax = 400; % y坐标的范围
    zmin = 0; zmax = 350; % z坐标的范围
elseif npoints==50
    xmin = 0; xmax = 500; % x坐标的范围
    ymin = 0; ymax = 500; % y坐标的范围
    zmin = 0; zmax = 400; % z坐标的范围
elseif npoints>50&&npoints<=100     %2*1*1
    xmin = 0; xmax = 1000; % x坐标的范围
    ymin = 0; ymax = 500; % y坐标的范围
    zmin = 0; zmax = 400; % z坐标的范围
elseif npoints>100&&npoints<=200      %2*2*1
    xmin = 0; xmax = 1000; % x坐标的范围
    ymin = 0; ymax = 1000; % y坐标的范围
    zmin = 0; zmax = 400; % z坐标的范围
elseif npoints>200&&npoints<=400      %2*2*2
    xmin = 0; xmax = 1000; % x坐标的范围
    ymin = 0; ymax = 1000; % y坐标的范围
    zmin = 0; zmax = 800; % z坐标的范围
elseif npoints>400&&npoints<=800     %2*2*4
    xmin = 0; xmax = 1000; % x坐标的范围
    ymin = 0; ymax = 1000; % y坐标的范围
    zmin = 0; zmax = 1600; % z坐标的范围
elseif npoints>800&&npoints<=1000    %2*2*5
    xmin = 0; xmax = 1000; % x坐标的范围
    ymin = 0; ymax = 1000; % y坐标的范围
    zmin = 0; zmax = 2000; % z坐标的范围
end


end

