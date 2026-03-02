% plot figures in the manuscript from data
clear; clc
close all

%% Figure 4b -- Band structure
load("FRE_cross_center.mat")
selectfre = FRE;
imagind = [1];
newind = [2, 3];

hax = axes(figure);
hold on 

h_red = [];
h_blue = [];
h_magenta = [];

for i = 1 : length(selectfre)
    if ismember(i, imagind)
        h = plot(hax, i, imag(selectfre(i)), ...
            'r*-', 'MarkerSize', 6, 'LineWidth', 1);
        if isempty(h_red)
            h_red = h;
        end
    elseif ismember(i, newind)
        h = plot(hax, i, real(selectfre(i)), ...
            'b+-', 'MarkerSize', 6, 'LineWidth', 1);
        if isempty(h_blue)
            h_blue = h;
        end
    else
        h = plot(hax, i, real(selectfre(i)), ...
            'm.-', 'MarkerSize', 12, 'LineWidth', 1);
        if isempty(h_magenta)
            h_magenta = h;
        end
    end
end

legend_handles = [];
legend_labels = {};

if ~isempty(h_red)
    legend_handles = [legend_handles, h_red];
    legend_labels{end+1} = 'new born imaginary eigenvalues';
end

if ~isempty(h_blue)
    legend_handles = [legend_handles, h_blue];
    legend_labels{end+1} = 'new born real eigenvalues';
end

if ~isempty(h_magenta)
    legend_handles = [legend_handles, h_magenta];
    legend_labels{end+1} = 'original real eigenvalues';
end

legend(legend_handles, legend_labels, 'Location', 'southeast', 'FontSize',16);

xlabel('Eigenvalue Index', 'Interpreter', 'latex', 'FontSize',16)
ylabel('frequency $\omega a/(2\pi c)$', 'Interpreter', 'latex', 'FontSize',16)

%% Figure 4c -- Light localization
load("F_data_cross_center.mat")
elements = F_data.elements;
nodes = F_data.nodes;
abs_q1_all = F_data.abs_q1_all;

figure
patch('Faces', elements(1 : 3, :).', 'Vertices', nodes.', 'FaceVertexCData', abs_q1_all, ...
    'FaceColor', 'interp', 'EdgeColor', 'interp'), hold on
colorbar
axis equal
axis off


%% Figure 4e -- Band structure
load("FRE_rectangle_center.mat")
selectfre = FRE;
imagind = [0];
newind = [2:4];
mm = 6;

hax = axes(figure);
hold on 
grid on
h_red = [];
h_blue = [];
h_magenta = [];

for i = 1 : length(selectfre)
    if ismember(i, imagind)
        h = plot(hax, i, imag(selectfre(i)), ...
            'r*-', 'MarkerSize', 12, 'LineWidth', 1);
        if isempty(h_red)
            h_red = h;
        end
    elseif ismember(i, newind)
        h = plot(hax, i, real(selectfre(i)), ...
            'b+-', 'MarkerSize', 6, 'LineWidth', 1);
        if isempty(h_blue)
            h_blue = h;
        end
    else
        h = plot(hax, i, real(selectfre(i)), ...
            'm.-', 'MarkerSize', 12, 'LineWidth', 1);
        if isempty(h_magenta)
            h_magenta = h;
        end
    end
end

legend_handles = [];
legend_labels = {};

if ~isempty(h_red)
    legend_handles = [legend_handles, h_red];
    legend_labels{end+1} = 'new born imaginary eigenvalues';
end

if ~isempty(h_blue)
    legend_handles = [legend_handles, h_blue];
    legend_labels{end+1} = 'new born real eigenvalues';
end

if ~isempty(h_magenta)
    legend_handles = [legend_handles, h_magenta];
    legend_labels{end+1} = 'original real eigenvalues';
end

legend(legend_handles, legend_labels, 'Location', 'southeast', 'FontSize', 16);
xlabel('Eigenvalue Index', 'Interpreter', 'latex', 'FontSize',16)
ylabel('frequency $\omega a/(2\pi c)$', 'Interpreter', 'latex', 'FontSize',16)



%% Figure 4f -- Light localization
load("F_data_rectangle_center.mat")
elements = F_data.elements;
nodes = F_data.nodes;
abs_q1_all = F_data.abs_q1_all;

figure
patch('Faces', elements(1 : 3, :).', 'Vertices', nodes.', 'FaceVertexCData', abs_q1_all, ...
    'FaceColor', 'interp', 'EdgeColor', 'interp'), hold on
colorbar
axis equal
axis off
