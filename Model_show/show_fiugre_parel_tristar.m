%% 绘制菱形中心星形图案
clear; clc; close all;

a = 10;
r1 = a * 0.3075;
r2 = a * 0.0615;
theta = pi / 3;
alp = 2 * theta;

% 创建图形窗口
figure('Color', 'white', 'Position', [100, 100, 600, 600]);
hold on;
axis equal;
axis off  % 设置坐标轴范围，留出边距用于标注
grid off;
box off;

% 设置颜色
diamond_color = [1.00 0.25 0.25];  % 红色
para_color = [0.00 0.75 1.00];  % 青蓝色

% 绘制平行四边形背景
% 平行四边形参数
para_vertices = [0 - 3 / 4 * a,	-a * (sqrt(3) / 4);
                a / 4, -a * (sqrt(3) / 4);
                3 / 4 * a, a * (sqrt(3) / 4);
                -a / 4, a * (sqrt(3) / 4)] + [3/4 * a, a*(sqrt(3)/4)];

% 绘制并填充菱形
fill(para_vertices(:,1), para_vertices(:,2), para_color, ...
     'EdgeColor', 'k', 'LineWidth', 1.5);

% 2. 绘制浅蓝色菱形（旋转45度的正方形）
% 菱形参数
diamond_vertices = [r1 * cos(theta), r1 * sin(theta);
                    r2 * cos(alp), r2 * sin(alp);
                    -r1, 0;
                    r2 * cos(2 * alp), r2 * sin(2 * alp);
                    r1 * cos(-theta), r1 * sin(-theta);
                    r2, 0] + [3/4 * a, a*(sqrt(3)/4)];

% 绘制并填充菱形
fill(diamond_vertices(:,1), diamond_vertices(:,2), diamond_color, ...
     'EdgeColor', 'k', 'LineWidth', 1.5);

%% 添加标注
% 1.平行四边形标注
text(a/2, -1, '$a_1$', 'Interpreter', 'latex', ...
     'HorizontalAlignment', 'center', 'FontSize', 30);
text(a * 0.1, a/2, sprintf('$a_2$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数


% 2. 三芒星的半径标注
% 水平半径
plot([3/4*a, 3/4*a-r1], [a*(sqrt(3)/4), a*(sqrt(3)/4)], 'Color', [1, 1, 0], 'LineWidth', 2);
plot([3/4*a, 3/4*a], [a*(sqrt(3)/4) - 0.1, a*(sqrt(3)/4) + 0.1], 'Color', [1, 1, 0], 'LineWidth', 2);
plot([3/4*a-r1 - 0.05, 3/4*a-r1- 0.05], [a*(sqrt(3)/4) - 0.1, a*(sqrt(3)/4) + 0.1], 'Color', [1, 1, 0], 'LineWidth', 2);
text(0.6 * a, 0.55 * a, sprintf('$r_1$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数




% 小半径
plot([3/4*a, 3/4*a+r2], [a*(sqrt(3)/4), a*(sqrt(3)/4)], 'Color', [1, 1, 1],  'LineWidth', 2);
plot([3/4*a, 3/4*a], [a*(sqrt(3)/4) - 0.1, a*(sqrt(3)/4) + 0.1], 'Color', [1, 1, 1],  'LineWidth', 2);
plot([3/4*a+r2, 3/4*a+r2], [a*(sqrt(3)/4) - 0.1, a*(sqrt(3)/4) + 0.1], 'Color',  [1, 1, 1],  'LineWidth', 2);
text(0.9 * a, 0.4 * a, sprintf('$r_2$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数

% 分割三芒星
plot([3/4*a, 3/4*a - r2 * cos(theta)], [a*(sqrt(3)/4), a*(sqrt(3)/4) + r2 * sin(theta)], 'k-', 'LineWidth', 1);
plot([3/4*a, 3/4*a - r2 * cos(theta)], [a*(sqrt(3)/4), a*(sqrt(3)/4) - r2 * sin(theta)], 'k-', 'LineWidth', 1);
plot([3/4*a, 3/4*a + r1 * cos(theta)], [a*(sqrt(3)/4), a*(sqrt(3)/4) + r1 * sin(theta)], 'k-', 'LineWidth', 1);
plot([3/4*a, 3/4*a + r1 * cos(theta)], [a*(sqrt(3)/4), a*(sqrt(3)/4) - r1 * sin(theta)], 'k-', 'LineWidth', 1);



%% 添加向量箭头（根据您的描述）
% 设置箭头参数
arrow_length = 3;      % 箭头长度
arrow_width = 3;       % 箭头线宽
arrow_color1 = [0 0 0]; % 品红箭头
arrow_color2 = [0 0 0]; % 绿色箭头

% 1. 正方形下边中心的水平箭头（指向正下方）
% 起点：正方形下边中点，坐标为(L/2, 0)
% 向量分量：(0, -arrow_length) 表示向下
quiver(0, 0, a/4, a*(sqrt(3)/4), 2, ...
       'Color', arrow_color1, 'LineWidth', arrow_width, ...
       'MaxHeadSize', 0.2, 'AutoScale', 'on');

% 2. 正方形左边中心的垂直箭头（指向正左方）
% 起点：正方形左边中点，坐标为(0, L/2)
% 向量分量：(-arrow_length, 0) 表示向左
quiver(0, 0, a, 0, 1, ...
       'Color', arrow_color2, 'LineWidth', arrow_width, ...
       'MaxHeadSize', 0.2, 'AutoScale', 'on');

% 可选：添加箭头标签
% text(L/2, -arrow_length-0.5, '向量1', ...
%      'HorizontalAlignment', 'center', 'FontSize', 12);
% text(-arrow_length-0.5, L/2, '向量2', ...
%      'HorizontalAlignment', 'center', 'FontSize', 12, 'Rotation', 90);



%% 5. 添加60度角度标注（在左下角顶点）
% 角度标注参数
base1 = [a, 0];
base2 = [a / 2, a * (sqrt(3) / 2)];
origin = (base2 + base1) / 2;
angle_radius = 0.3;            % 角度弧线半径
angle_label_offset = 0.2;      % 角度标签偏移量

% 计算两个边的角度（以度为单位）
angle1 = atan2(base1(2), base1(1));  % base1与x轴的夹角
angle2 = atan2(base2(2), base2(1));  % base2与x轴的夹角

% 确保角度标注是逆时针方向，且标注的是较小的内角
if angle2 < angle1
    angle2 = angle2 + 2*pi;
end

% 生成弧线上的点（从angle1到angle2）
theta = linspace(angle1, angle2, 50);
arc_x = origin(1) + angle_radius * cos(theta);
arc_y = origin(2) + angle_radius * sin(theta);

% 绘制60度弧线
plot(arc_x, arc_y, 'k-', 'LineWidth', 1.5);

% 添加角度标签"60°"
% 计算标签位置（弧线中点向外偏移一点）
mid_angle = (angle1 + angle2) / 2;
label_x = origin(1) + (angle_radius + angle_label_offset) * cos(mid_angle) + 0.5;
label_y = origin(2) + (angle_radius + angle_label_offset) * sin(mid_angle) + 0.3;

text(label_x, label_y, '60$^\circ$', ...
     'FontSize', 20, 'FontWeight', 'bold', ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
     'Interpreter', 'latex', 'Color', [0 0 0]);