%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  将样本分成不同编队数量的模块，并得到不同模块对应的序列
%  整除： 若共有20个样本，分成4组，则结果为1~5,6~10,11~15,16~20
%  非整除：若共有21个样本，分成4组，则结果为1~5,6~10,11~15,16~21；余数放至最后一组
% 
%   
%
%                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dex] = G_dex(mint,maxt,zqnum)


% 定义组数和每组的大致数量（向下取整）  
numGroups = maxt-mint+1;  
groupSize = floor(zqnum / numGroups);  
  
% 初始化groups矩阵  
% groups矩阵将有两列，第一列是每组的起始索引，第二列是每组的结束索引（包含）  
groups = zeros(numGroups, 2);  
 
% 计算每组的起始和结束索引  
startIdx = 1;  
for i = 1:numGroups  
    % 如果不是最后一组，则使用groupSize作为结束索引（包含）  
    % 否则，使用totalPoints作为最后一组的结束索引  
    if i < numGroups  
        endIdx = startIdx + groupSize - 1;  
    else  
        endIdx = zqnum;  
    end  
      
    % 存储起始和结束索引  
    groups(i, :) = [startIdx, endIdx];
  
      
    % 更新下一组的起始索引  
    startIdx = endIdx + 1;  
end  
  
dex=groups;









