function [parameters] = graph_modi1(parameters,delta_x)

parameters(1:3,1) = parameters(1:3,1) + delta_x(1:3,1);
% parameters = parameters + delta_x;
end