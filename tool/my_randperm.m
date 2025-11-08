% function  [Xiter,gnditer] = my_randperm(A,gnd,C,n,l)
% %{
% l = 69
% %}
% gnd = gnd';
% count = zeros(1,C);
% Xiter = [];
% B = [];
% D = [];
% gndB = [];
% gndD = [];
% for i = 1:n
%   idx = gnd(i);
%   count(idx) =   count(idx)+1;
% end
% c_s = floor(l/C);  %每个簇取几个
% for i = 1:C
%     if i == 1
%        sum_pre(i) = count(i);
%     else
%         sum_pre(i) = sum_pre(i-1)+count(i);
%     end
%     index = randperm(c_s);
%     Btemp = A(:,(i-1)*(c_s)+index(1:c_s));
%     B = [B,Btemp];
%     gndBtemp = gnd(sum_pre(i)-c_s+1:sum_pre(i));
%     gndB = [gndB,gndBtemp];
%     if(i == 1)
%         Dtemp = A(:,c_s+1:sum_pre(i));
%         gndDtemp = gnd(c_s+1:sum_pre(i));
%     else Dtemp = A(:,sum_pre(i-1)+c_s+1:sum_pre(i));
%         gndDtemp = gnd(sum_pre(i-1)+c_s+1:sum_pre(i));
%     end
%     D = [D,Dtemp];
%     gndD = [gndD,gndDtemp];
% end
% Xiter = [B,D];
% gnditer = [gndB,gndD];
% gnditer = gnditer';


function [A, gnd] = my_randperm(A, gnd, C, n, l)
B = [];
D = [];
gndB = [];
gndD = [];

% 遍历每一类
for i = 1:C
    % 获取当前类的样本索引
    class_indices = find(gnd == i); % 找到 gnd 中属于第 i 类的样本
    num_samples_in_class = length(class_indices); % 当前类的样本数
    
    % 随机打乱当前类的样本索引
    shuffled_indices = class_indices(randperm(num_samples_in_class));
    
    % 计算当前类分配给 B 的样本数
    num_samples_for_B = round(l * num_samples_in_class / n); % 按比例分配给 B 的样本数
    
    % 分配样本到 B 和 D
    Btemp = A(:, shuffled_indices(1:min(num_samples_for_B, num_samples_in_class)));
    B = [B, Btemp];
    gndBtemp = gnd(shuffled_indices(1:min(num_samples_for_B, num_samples_in_class)));
    gndB = [gndB; gndBtemp];
    
    if num_samples_in_class > num_samples_for_B
        Dtemp = A(:, shuffled_indices(num_samples_for_B+1:end));
        D = [D, Dtemp];
        gndDtemp = gnd(shuffled_indices(num_samples_for_B+1:end));
        gndD = [gndD; gndDtemp];
    end
end

% 清理并合并数据
clear A
A = [B, D];
clear gnd
gnd = [gndB; gndD];

