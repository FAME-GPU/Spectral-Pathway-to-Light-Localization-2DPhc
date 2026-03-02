clear; clc
close all

L = 20;
d = 0.28 * L;
r = 2.4;

% 创建图形窗口
figure('Color', 'white', 'Position', [100, 100, 600, 600]);
hold on;
axis equal;
axis off  % 设置坐标轴范围，留出边距用于标注
grid off;
box off;

% 设置颜色
square_color = [0.00 0.75 1.00];  % 青蓝色
circle_color = [1.00 0.25 0.25];  % 红色

% 绘制正方形背景
rectangle('Position', [0, 0, L, L], ...
          'FaceColor', square_color, ...
          'EdgeColor', 'k', 'LineWidth', 1);

% 绘制四个圆
for i = 1:2
    for j = 1:2
        % 圆心位置：由于每个圆与相邻边相切，圆心距离两边各为r
        center_x = L / 2 - (2 * i - 3) * d / 2;
        center_y = L / 2 - (2 * j - 3) * d / 2;
        
        % 绘制圆（通过绘制高曲率矩形实现）
        rectangle('Position', [center_x - r, center_y - r, 2*r, 2*r], ...
                  'Curvature', [1, 1], ...
                  'FaceColor', circle_color, ...
                  'EdgeColor', 'k', 'LineWidth', 1);
    end
end

%% 添加标注
% 1. 正方形边长标注
% annotation('arrow', [0.15, 0.15], [0.07, 0.93], 'LineWidth', 2, 'Color', 'k');
% annotation('arrow', [0.93, 0.07], [0.15, 0.15], 'LineWidth', 2, 'Color', 'k');
text(L/2, -1, '$a_1$', 'Interpreter', 'latex', ...
     'HorizontalAlignment', 'center', 'FontSize', 30);
text(-1.5, L/2, sprintf('$a_2$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数


% 2. 圆的半径标注（以左下角圆为例）
% 水平半径
plot([(L - d) / 2, (L - d) / 2 + r], [(L - d) / 2, (L - d) / 2], 'k-', 'LineWidth', 1);
plot([(L - d) / 2, (L - d) / 2], [(L - d) / 2 - 0.3, (L - d) / 2 + 0.3], 'k-', 'LineWidth', 1);
plot([(L - d) / 2 + r, (L - d) / 2 + r], [(L - d) / 2 - 0.3, (L - d) / 2 + 0.3], 'k-', 'LineWidth', 1);
text(0.42 * L, 0.32 * L, sprintf('$r$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数

% 圆间距
plot([(L + d) / 2, (L + d) / 2], [(L - d) / 2, (L + d) / 2], 'k-', 'LineWidth', 1);
plot([(L + d) / 2 - 0.3, (L + d) / 2 + 0.3], [(L - d) / 2, (L - d) / 2], 'k-', 'LineWidth', 1);
plot([(L + d) / 2 - 0.3, (L + d) / 2 + 0.3], [(L + d) / 2, (L + d) / 2], 'k-', 'LineWidth', 1);
text((L + d) / 2 + 0.08 * L, (L) / 2, sprintf('$d$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数



%% 添加向量箭头（根据您的描述）
% 设置箭头参数
arrow_length = 3;      % 箭头长度
arrow_width = 3;       % 箭头线宽
arrow_color1 = [0 0 0]; % 品红箭头
arrow_color2 = [0 0 0]; % 绿色箭头

% 1. 正方形下边中心的水平箭头（指向正下方）
% 起点：正方形下边中点，坐标为(L/2, 0)
% 向量分量：(0, -arrow_length) 表示向下
quiver(0, 0, 0, 1, 20, ...
       'Color', arrow_color1, 'LineWidth', arrow_width, ...
       'MaxHeadSize', 0.2, 'AutoScale', 'on');

% 2. 正方形左边中心的垂直箭头（指向正左方）
% 起点：正方形左边中点，坐标为(0, L/2)
% 向量分量：(-arrow_length, 0) 表示向左
quiver(0, 0, 1, 0, 20, ...
       'Color', arrow_color2, 'LineWidth', arrow_width, ...
       'MaxHeadSize', 0.2, 'AutoScale', 'on');

% 可选：添加箭头标签
% text(L/2, -arrow_length-0.5, '向量1', ...
%      'HorizontalAlignment', 'center', 'FontSize', 12);
% text(-arrow_length-0.5, L/2, '向量2', ...
%      'HorizontalAlignment', 'center', 'FontSize', 12, 'Rotation', 90);

% 调整图形范围，确保箭头完整显示
axis([-arrow_length-2 L+2 -arrow_length-2 L+2]);






hold off;
