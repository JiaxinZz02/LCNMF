function [Q] = update_sum(X,view_num,K)
    Q = zeros(size(X{1},1),size(X{1},2));
    for i = 1:view_num
        if i ~= K
           Q = Q + X{i};
        end
    end
    Q = Q./(view_num-1);
end