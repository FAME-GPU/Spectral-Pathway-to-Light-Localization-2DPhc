%% 绘制菱形中心星形图案
clear; clc; 
% close all;

len = 10;
num = 5;
a = len / num;

% 创建图形窗口
figure('Color', 'white', 'Position', [100, 100, 600, 600]);
hold on;
axis equal;
axis off  % 设置坐标轴范围，留出边距用于标注
grid off;
box off;

% 设置颜色
diamond_color = [1.00 0.25 0.25];  % 红色
square_color = [0.00 0.75 1.00];  % 青蓝色

% 绘制正方形背景
rectangle('Position', [0, 0, len, len], ...
          'FaceColor', square_color, ...
          'EdgeColor', 'k', 'LineWidth', 1);

% 2. 绘制红色十字架
% 十字架参数
r1 = 0.3 * a;
r2 = 0.2 * a;

for i = 1 : num
    for j = 1 : num

        center = [(i - 1) * a, (j - 1) * a] + [a, a] / 2;

        rect_vertices = [-r1, -r2;
                         r1,  -r2;
                         r1,  r2;
                         -r1, r2;] + center;
        
        % if  i == 3 && j ==3
        % % 绘制并填充菱形
        fill(rect_vertices(:,1), rect_vertices(:,2), diamond_color, ...
             'EdgeColor', 'k', 'LineWidth', 1.5);
        % else
        %     fill(rect_vertices(:,1), rect_vertices(:,2), [1,1,0], ...
        %      'EdgeColor', 'k', 'LineWidth', 1.5);
        % end
    end
end

%% 添加标注
% 1.正方形标注
text(len/2, -1, '$a_1$', 'Interpreter', 'latex', ...
     'HorizontalAlignment', 'center', 'FontSize', 30);
text(-1, len/2, sprintf('$a_2$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 30, 'Interpreter', 'latex');  % 关键参数


% 单胞长度
plot([a*3/2, a*3/2], [a/2,a*3/2], 'Color', [0, 0, 0], 'LineWidth', 2);
plot([a*3/2 + 0.1, a*3/2 - 0.1], [a/2, a/2], 'Color', [0, 0, 0], 'LineWidth', 2);
plot([a*3/2 + 0.1, a*3/2 - 0.1], [a*3/2, a*3/2], 'Color', [0, 0, 0], 'LineWidth', 2);
text(a*1.2, a, sprintf('$a$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 36, 'Interpreter', 'latex');  % 关键参数


% 水平半径
plot([2.5*a-r1, 2.5*a+r1], [2.5*a-r2, 2.5*a-r2], 'Color', [1, 1, 0], 'LineWidth', 2);
% plot([gap, gap], [gap + R - 0.1, gap + R + 0.1], 'Color', [1, 1, 0], 'LineWidth', 2);
% plot([gap + R, gap + R], [gap + R - 0.1, gap + R + 0.1], 'Color', [1, 1, 0], 'LineWidth', 2);
text(2.5*a, 2*a, sprintf('$d_1$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 36, 'Interpreter', 'latex');  % 关键参数

% 竖直半径
plot([2.5*a+r1, 2.5*a+r1], [2.5*a-r2, 2.5*a+r2], 'Color', [1, 1, 1], 'LineWidth', 2);
% plot([gap + R - 0.1, gap + R + 0.1], [gap, gap], 'Color', [1, 1, 1], 'LineWidth', 2);
% plot([gap + R - 0.1, gap + R + 0.1], [gap + R, gap + R], 'Color', [1, 1, 1], 'LineWidth', 2);
text(3*a, 2.9*a, sprintf('$d_2$'), ...
     'HorizontalAlignment', 'center', 'FontSize', 36, 'Interpreter', 'latex');  % 关键参数





%% 添加向量箭头（根据您的描述）
% 设置箭头参数
arrow_length = 3;      % 箭头长度
arrow_width = 3;       % 箭头线宽
arrow_color1 = [0 0 0]; % 品红箭头
arrow_color2 = [0 0 0]; % 绿色箭头

% 1. 正方形下边中心的水平箭头（指向正下方）
% 起点：正方形下边中点，坐标为(L/2, 0)
% 向量分量：(0, -arrow_length) 表示向下
quiver(0, 0, len, 0, 1, ...
       'Color', arrow_color1, 'LineWidth', arrow_width, ...
       'MaxHeadSize', 0.2, 'AutoScale', 'on');

% 2. 正方形左边中心的垂直箭头（指向正左方）
% 起点：正方形左边中点，坐标为(0, L/2)
% 向量分量：(-arrow_length, 0) 表示向左
quiver(0, 0, 0, len, 1, ...
       'Color', arrow_color2, 'LineWidth', arrow_width, ...
       'MaxHeadSize', 0.2, 'AutoScale', 'on');