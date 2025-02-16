function score = evaluateSectorOptimized(Fx_in, Fy_in,useGPU,area)
    % 传输数据到GPU（如启用）
    if useGPU
        % Fx_in = gpuArray(F_x);
        % Fy_in = gpuArray(F_y);
    end
    % 改进的面积计算
if numel(Fx_in) < 3
    area_in = 0;
    
else
    % 极角
    shp = alphaShape(double(Fx_in), double(Fy_in));  % 50 这个值可以调整

    % shp.Alpha=criticalAlpha(shp,'one-region');%目标单连通区域，自动设置最优半径
    shp.Alpha=min(criticalAlpha(shp,'one-region'),10);
    [~,by] = boundaryFacets(shp);  % 获取边界点
    Fx_in=by(:,1);
    Fy_in=by(:,2);


    % figure;
    % scatter(Fx_in, Fy_in, 5, 'filled');
    % xlabel('X (mm)');
    % ylabel('Y (mm)');
    % title('五连杆末端点云轨迹');
    % xlim([-200, 200]);
    % ylim([-350, -100]);
    % axis equal;
    % grid on;


    center_x = mean(Fx_in);
    center_y = mean(Fy_in);
    % 计算相对质心的极角
    [~, idx] = sort(atan2(Fy_in - center_y, Fx_in - center_x));
    sorted_x = Fx_in(idx);
    sorted_y = Fy_in(idx);                
    % 多边形面积公式
    x_shift = circshift(sorted_x, -1);
    y_shift = circshift(sorted_y, -1);
    area_in = 0.5 * abs(sum(sorted_x.*y_shift - x_shift.*sorted_y));
end
    % 得分公式：（面积比 - 惩罚项）
    score_ratio = area_in / area;
    % score = max(0, score_ratio - penalty); % 确保得分非负
    score = max(0, score_ratio); % 确保得分非负

    score = gather(score);
end

