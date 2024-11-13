function Z1 = transfer_function_continues(Z2, x, R, freq)
%TRANSFER_FUNCTION_CONTINUES 连续计算传递函数
%   Z1 = TRANSFER_FUNCTION_CONTINUES(Z2, x, R, freq) 计算连续多个位置的传递函数
%   
%   输入参数:
%       Z2: 初始的传递函数
%       x: 位置数组
%       R: 曲率半径数组
%       freq: 频率
%
%   输出参数:
%       Z1: 最终的传递函数

    % 获取数组长度
    N = length(x);

    % 循环计算
    for idx = N:-1:2
        x2 = x(idx);
        R2 = R(idx);
        x1 = x(idx-1);
        R1 = R(idx-1);
        
        % 调用基本传递函数计算
        Z2 = transfer_function(Z2, x1, x2, R1, R2, freq);
    end

    Z1 = Z2;
end