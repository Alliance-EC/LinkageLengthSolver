function updateWaitbar(h, total)
batchSize=1000;
h.UserData = h.UserData + batchSize;
percentComplete = h.UserData / total * 100; % 计算完成百分比
% if abs(percentComplete-30)<0.01 || abs(percentComplete-60)<0.01
waitbar(percentComplete / 100, h, sprintf('完成 %.2f%%', percentComplete)); % 更新进度条并显示百分比
end
