function data_find(L1,L2,L3,L4,L5,idx)
r=load("data\all_results.mat");
if nargin==5
    % 使用 cellfun 查找符合条件的索引
    k=1;
    indices = abs(r(:,1));
end
if nargin==1
   indices=L1;
end
% 显示匹配的索引
if isempty(indices)
    disp('没有找到符合条件的索引。');
    return;
else
    disp('匹配的索引:');
    disp(indices);
end

figure;
scatter(r.results{indices(1)}.F_x,r.results{indices(1)}.F_y,5,'filled');
hold on;

% Plot the circles
for r = 100:50:450
    theta = linspace(5*pi/4, 7*pi/4, 1000); % 足够多的点使曲线平滑
    x = r * cos(theta);
    y = r * sin(theta);
    plot(x, y, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); % 灰色虚线
end

% Add the transparent fan ring
theta_fan = linspace(1.25*pi, 1.75*pi, 100); % Angular range from 1.25pi to 1.75pi
r_inner = 100; % Inner radius
r_outer = 350; % Outer radius

% Coordinates for the inner and outer edges of the fan ring
x_inner = r_inner * cos(theta_fan);
y_inner = r_inner * sin(theta_fan);
x_outer = r_outer * cos(theta_fan);
y_outer = r_outer * sin(theta_fan);

% Create the filled sector (fan ring) by connecting the inner and outer edges
fill([0, x_outer, fliplr(x_inner)], [0, y_outer, fliplr(y_inner)], 'y', 'FaceAlpha', 0.4, 'EdgeColor', 'none'); 

hold off;
xlabel('X (mm)'); ylabel('Y (mm)');
title('五连杆末端点云轨迹');
xlim([-200,200])
ylim([-350,-100])
axis equal;
grid on;
end
