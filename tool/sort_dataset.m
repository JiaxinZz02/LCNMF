function [res_X, res_gnd] = sort_dataset(X, gnd)
    % 对 gnd 进行排序，并获取排序索引
    [res_gnd, idx] = sort(gnd);
    % 根据排序索引对 X 的列进行重排
    for i=1:size(X,2)
        res_X{i} = X{i}(:, idx);
    end
end