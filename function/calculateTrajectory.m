function [F_x_final, F_y_final] = calculateTrajectory(L1, L2, L3, L4, L5,L6, useGPU,sector)
% 固定参数
n = 120;  % 适当降低采样精度以节省计算资源
A = [-L5/2, 0]; E = [L5/2, 0]; % 固定点
% 生成角度网格
theta1 = linspace(0, 2*pi, n);
theta4 = linspace(0, 2*pi, n);
theta1=single(theta1);
theta4=single(theta4);
if useGPU
    theta1 = gpuArray(theta1);
    theta4 = gpuArray(theta4);
end

% 后续计算与原代码相同，此处省略...
% 创建网格并向量化
[theta1_grid, theta4_grid] = meshgrid(theta1, theta4);
theta1_vec = theta1_grid(:);
theta4_vec = theta4_grid(:);

% 计算B点和D点坐标（向量化计算）
Bx = A(1) + L1 * cos(theta1_vec);
By = A(2) + L1 * sin(theta1_vec);
Dx = E(1) + L4 * cos(theta4_vec);
Dy = E(2) + L4 * sin(theta4_vec);

% 计算连杆方程参数
delta_x = Dx - Bx;
delta_y = Dy - By;

% 计算判别式（完全向量化）
A0 = 2 * L2 * delta_x;
B0 = 2 * L2 * delta_y;
C0 = L2^2 + delta_x.^2 + delta_y.^2 - L3^2;
discriminant = A0.^2 + B0.^2 - C0.^2;

A1 = 2 * L3 * (-delta_x);
B1 = 2 * L3 * (-delta_y);
C1 = L3^2 + delta_x.^2 + delta_y.^2 - L2^2;
discriminant1 = A1.^2 + B1.^2 - C1.^2;

% 初步筛选有效索引
valid_idx = discriminant >= 0 & discriminant1 >= 0;
if ~any(valid_idx)
    error('No valid configurations found');
end
% 提取有效角度组合
theta1_valid = theta1_vec(valid_idx);
theta4_valid = theta4_vec(valid_idx);
Bx_valid = Bx(valid_idx);
By_valid = By(valid_idx);
Dx_valid = Dx(valid_idx);
Dy_valid = Dy(valid_idx);

% 计算theta2（只计算有效点）
sqrt_disc = sqrt(discriminant(valid_idx));
theta2 = 2 * atan2((B0(valid_idx) + sqrt_disc), (A0(valid_idx) + C0(valid_idx)));

% 计算C点坐标
Cx = Bx_valid + L2 * cos(theta2);
Cy = By_valid + L2 * sin(theta2);

% 几何约束条件判断（向量化）
cha1 = (Dx_valid - Cx) .* (E(2) - Cy) - (Dy_valid - Cy) .* (E(1) - Cx);
cha2 = (Bx_valid - A(1)) .* (Cy - A(2)) - (By_valid - A(2)) .* (Cx - A(1));

% 处理除零情况
delta_DCx = Dx_valid - Cx;
non_zero = delta_DCx ~= 0;
flag1 = zeros(size(delta_DCx), 'like', delta_DCx);
flag1(non_zero) = (Dy_valid(non_zero) - Cy(non_zero)) ./ delta_DCx(non_zero);

% 避免条件判断中的除零错误
flag2 = A(2) > (flag1 .* (A(1) - Cx) + Cy);

% 最终有效条件
condition_above = Cy > By_valid; 

% 修改有效点判断逻辑
final_valid = cha1 < 0 | cha2 > 0 | (flag2 & (flag1 < 0)); 
valid_points = (~final_valid) & condition_above; 

% 计算最终坐标
F_x = Cx(valid_points) + (L6/L2)*(Cx(valid_points) - Bx_valid(valid_points));
F_y = Cy(valid_points) + (L6/L2)*(Cy(valid_points) - By_valid(valid_points));

% Y坐标筛选
y_valid = F_y > 0;
F_x = F_x(y_valid);
F_y = -F_y(y_valid);

% 极径条件（使用平方避免开方运算）
r_sq = F_x.^2 + F_y.^2;
valid_r = (r_sq >= sector.r_min^2) & (r_sq <= sector.r_max^2);

% 角度条件（通过叉积判断方向）
cross_min = F_x * sector.sin_theta_min - F_y * sector.cos_theta_min;
cross_max = F_x * sector.sin_theta_max - F_y * sector.cos_theta_max;
valid_theta = (cross_min <= 0) & (cross_max >= 0);

% % 综合掩膜
valid_mask = valid_r & valid_theta;
% 获取区域内的点
Fx_in = F_x(valid_mask);
Fy_in = F_y(valid_mask);

% 返回最终坐标
F_x_final = gather(Fx_in);
F_y_final = gather(Fy_in);
end