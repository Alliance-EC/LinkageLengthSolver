function [value]=leg_find(object_phi0,object_l0)
%LEG_FIND 此处显示有关此函数的摘要
%   此处显示详细说明
    s=load("data/leg_trace.mat");
    phi0_diff = abs(s.phi0 - object_phi0);
    phi1_diff = abs(s.valid_theta1 - object_phi0);
    % 设定一个容差（这里为 10e-3），可以根据需要调整
    tolerance = 10e-2;
    
    % 找出满足 phi0 差异小于容差的索引
    % valid_idx = (phi0_diff < tolerance);
    valid_idx = (phi1_diff < tolerance);
    % 提取满足条件的值
    value = [s.phi0(valid_idx), s.l0(valid_idx), s.valid_theta1(valid_idx), s.valid_theta4(valid_idx)];
    
    % 输出结果
    disp(value);
    save("data\leg_find.mat");
end

