%% plot figures in the manuscript from data

clear
clc
close all

%% Figure 3b -- band structure
load('eigenvalues.mat')
frenum = 100;
knum = 41;
[row, col] = size(eig_fre);
fre = zeros(row, col/2);
for i = 1:col/2
    fre(1, i) = eig_fre(1,2*i);
    fre(2:end,i) = eig_fre(2:end,2*i-1) + 1i*eig_fre(2:end,2*i);
end
banddata = fre(2:end, :);
frequency = reshape(banddata, [frenum, knum]);
gamma = 0.94242;                % localization gamma
figure('Position', [100, 100, 1200, 800]);
set(gcf, 'Color', 'white');
denseline = frequency;
colors = lines(4);
p1 = []; p2 = []; p3 = [];
for i = 1:frenum
    if imag(denseline(i,1)) > 1e-6
        if isempty(p1)
            p1 = plot(imag(denseline(i,:)), ':', 'Color', 'r', 'LineWidth', 1.5, ...
                'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'r');
        else
            plot(imag(denseline(i,:)), ':', 'Color', 'r', 'LineWidth', 1.5, ...
                'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'r');
        end
        hold on
    elseif ismember(i, [6:20])
        if isempty(p2)
            p2 = plot(real(denseline(i,:)), '--', 'Color', 'b', 'LineWidth', 1.5, ...
                'Marker', 's', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
        else
            plot(real(denseline(i,:)), '--', 'Color', 'b', 'LineWidth', 1.5, ...
                'Marker', 's', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
        end
    else
        if isempty(p3)
            p3 = plot(real(denseline(i,:)), '-', 'Color', 'm', 'LineWidth', 1.2, ...
                'Marker', '.', 'MarkerSize', 8);
        else
            plot(real(denseline(i,:)), '-', 'Color', 'm', 'LineWidth', 1.2, ...
                'Marker', '.', 'MarkerSize', 8);
        end
        hold on
    end
end
hold off
axis([1 knum 0 1.05*max(max(abs(frequency)))]);
xlabel('wave vector $\mathbf{k}$', 'Interpreter', 'latex', 'FontSize', 42);
ylabel('frequency $\omega a/(2\pi c)$', 'Interpreter', 'latex', 'FontSize', 36);
grid on;
set(gca, 'GridAlpha', 0.3, 'LineWidth', 1);
box on;
legend([p1, p2, p3], 'newborn imaginary eigenvalues', 'newborn real eigenvalues', 'original real eigenvalues', ...
    'Location', 'northeast', 'FontSize', 20, 'Interpreter', 'latex', ...
    'Box', 'on');
set(gca, 'FontSize', 18, 'FontName', 'Arial');

%% Figure 3c -- localization
load('eigenvalues.mat')
load('mesh.mat')
load('parameters.mat')
load('eigenvalue_vector.mat')
num_plots = 20;
selected_curves = 1 : num_plots;
parameters.selected_wave_vec = 19;  % selected bloch vector order
ka = parameters.ka;
nodes_origin = mesh.nodes;
index = mesh.index;
elements = mesh.elements;
n = mesh.n_nodes;
m = mesh.n_free_nodes;

figure
hold on
y_range = max(nodes_origin(2,:)) - min(nodes_origin(2,:));
spacing = y_range * 1.1;
all_field_data = [];
for plot_idx = 1:num_plots
    parameters.selected_eigencurve = selected_curves(plot_idx);
    ev_select = result{parameters.selected_wave_vec}.ev(:, parameters.selected_eigencurve);
    ew_select = result{parameters.selected_wave_vec}.ew(parameters.selected_eigencurve);
    field = zeros(n, 1);
    q1 = ev_select(1 : m);
    q1 = q1 / norm(q1);
    field(index.free) = q1;
    if length(mesh.flag_quasiperiodic) == 4
        for i = 1 : length(index.node_quasiperiodic) / 2
            field(index.node_quasiperiodic{i + 2}) = exp(1i * ka(i, parameters.selected_wave_vec)) * ...
                field(index.node_quasiperiodic{i});
        end
    elseif length(mesh.flag_quasiperiodic) == 2
        field(index.node_quasiperiodic{2}) = exp(1i * ka(1, parameters.selected_wave_vec)) * ...
            field(index.node_quasiperiodic{1});
    end
    if parameters.flag.sep2gep
        field(mesh.index.nodes_material_unique) = field(mesh.index.nodes_material_unique) * ...
            sqrt(parameters.delta);
    end
    all_field_data = [all_field_data; abs(field)];
end
caxis_limits = [min(all_field_data), max(all_field_data)];
for plot_idx = 1:num_plots
    parameters.selected_eigencurve = selected_curves(plot_idx);
    % select eigenvalue and eigenvector
    ev_select = result{parameters.selected_wave_vec}.ev(:, parameters.selected_eigencurve);
    ew_select = result{parameters.selected_wave_vec}.ew(parameters.selected_eigencurve);
    field = zeros(n, 1);
    q1 = ev_select(1 : m);
    q1 = q1 / norm(q1);
    field(index.free) = q1;
    if length(mesh.flag_quasiperiodic) == 4
        for i = 1 : length(index.node_quasiperiodic) / 2
            field(index.node_quasiperiodic{i + 2}) = exp(1i * ka(i, parameters.selected_wave_vec)) * ...
                field(index.node_quasiperiodic{i});
        end
    elseif length(mesh.flag_quasiperiodic) == 2
        field(index.node_quasiperiodic{2}) = exp(1i * ka(1, parameters.selected_wave_vec)) * ...
            field(index.node_quasiperiodic{1});
    end
    if parameters.flag.sep2gep
        field(mesh.index.nodes_material_unique) = field(mesh.index.nodes_material_unique) * ...
            sqrt(parameters.delta);
    end
    translation = (plot_idx - 1) * spacing;
    nodes_translated = nodes_origin;
    nodes_translated(2, :) = nodes_translated(2, :) + translation;
    alpha_power = 0.3;
    abs_q1_all = abs(field);
    alpha_data = (abs_q1_all / max(abs_q1_all)).^alpha_power;
    patch('Faces', elements(1 : 3, :).', 'Vertices', nodes_translated.', ...
        'FaceVertexCData', abs_q1_all, 'FaceColor', 'interp', ...
        'EdgeColor', 'interp', ...
        'FaceVertexAlphaData', alpha_data, 'FaceAlpha', 'interp');
    text(-0.05, (plot_idx-1) * 0.048 + 0.02, num2str(plot_idx), 'Color', 'r');
    text((plot_idx-1) * 0.0496 + 0.025, -0.02, num2str(plot_idx), 'Color', 'b');

    for i = 1 : 19
        plot([0.05 * i, 0.05 * (i + 1/2)], [(plot_idx - 1) * spacing, (plot_idx - 1) * spacing + y_range], 'k'), hold on;
    end

end
caxis(caxis_limits);
colorbar
axis equal
axis off
hold off
set(gca, 'LooseInset', get(gca, 'TightInset'));

%% Figure 3d -- localized ratio
load("result_for_radius.mat")
num_Monte = parameters.num_Monte;
ka = parameters.ka;
records = [];
ev_select = result_for_radius{parameters.selected_wave_vec}.ev(:, parameters.selected_eigencurve);
ew_select = result_for_radius{parameters.selected_wave_vec}.ew(parameters.selected_eigencurve);
if ew_select<0
    isreal = 0;
else
    isreal = 1;
end
nodes_origin = mesh.nodes;
index = mesh.index;
elements = mesh.elements;
n = mesh.n_nodes;
m = mesh.n_free_nodes;
field = zeros(n, 1);
q1 = ev_select(1 : m);
q1 = q1 / norm(q1);
field(index.free) = q1;
if length(mesh.flag_quasiperiodic) == 4
    for i = 1 : length(index.node_quasiperiodic) / 2
        field(index.node_quasiperiodic{i + 2}) = exp(1i * ka(i, parameters.selected_wave_vec)) * ...
            field(index.node_quasiperiodic{i});
    end
elseif length(mesh.flag_quasiperiodic) == 2
    field(index.node_quasiperiodic{2}) = exp(1i * ka(1, parameters.selected_wave_vec)) * ...
        field(index.node_quasiperiodic{1});
end
if parameters.flag.sep2gep
    field(mesh.index.nodes_material_unique) = field(mesh.index.nodes_material_unique) * ...
        sqrt(parameters.delta);
end
nodes = nodes_origin;
field_on_elements = zeros(mesh.n_elements,1);
for i = 1 : mesh.n_elements
    field_on_elements(i) = sum(field(elements(1 : 3, i))) / 3;
end
num_material = max(elements(4,:))-1;
field_nodes = cell(num_material, 1);
shape = fieldnames(parameters.geometry);
evalstr = strcat('materials = parameters.geometry.', shape{2},'',';');
eval(evalstr);
diag_name = fieldnames(materials);
switch parameters.lattice.lattice_type
    case 'Square'
        x_Monte = rand(num_Monte, 1)*parameters.lattice.a1(1);
        y_Monte = rand(num_Monte, 1)*parameters.lattice.a2(2);
    case 'Parallelogram'
        vertex = parameters.geometry.boundary.polygon.vertex;
        v1 = vertex(2,:)-vertex(1,:);
        v2 = vertex(4,:)-vertex(1,:);
        ctheta = v1*v2'/(norm(v1)*norm(v2));
        theta = acos(ctheta);
        x_Monte = rand(num_Monte, 1)*parameters.lattice.a1(1);
        y_Monte = rand(num_Monte, 1)*parameters.lattice.a2(2);
        x_Monte = x_Monte + y_Monte*ctheta;
        y_Monte = y_Monte*sin(theta);
end
% Calculate the localization ratio using the Monte Carlo method
Montenodes = [x_Monte, y_Monte];
Ratio = 1.01:0.01:1.5;          % Increase  material radius
for ratio = Ratio
    switch shape{2}
        case 'circle'
            for F_tag = 1:num_material
                evalstr = strcat('radius = materials.',diag_name{F_tag},'.radius;');
                eval(evalstr);
                Radius = radius*ratio;
                evalstr = strcat('center = materials.',diag_name{F_tag},'.center;');
                eval(evalstr);
                x_ind = center(1);
                y_ind = center(2);
                tem_nodes = [];
                for i = 1:num_Monte
                    dist = sqrt((x_Monte(i)-x_ind)^2+(y_Monte(i)-y_ind)^2);
                    if dist < Radius
                        tem_nodes = [tem_nodes; i];
                    end
                end
                field_nodes{F_tag} = tem_nodes;
            end
        case 'polygon'
            if parameters.poly_num_r == 1
                for F_tag = 1:num_material
                    evalstr = strcat('radius = materials.',diag_name{F_tag},'.radius;');
                    eval(evalstr);
                    Radius = radius*ratio;
                    evalstr = strcat('shape_p = parameters.geometry.polygon.polygon',num2str(F_tag),'.function(Radius);');
                    eval(evalstr);
                    xv = shape_p(:,1);
                    yv = shape_p(:,2);
                    in = inpolygon(x_Monte, y_Monte, xv, yv);
                    field_nodes{F_tag} = find(in==1);
                end
            elseif parameters.poly_num_r == 2
                for F_tag = 1:num_material
                    evalstr = strcat('r1 = materials.',diag_name{F_tag},'.radius1;');
                    eval(evalstr);
                    R1 = r1*ratio;
                    evalstr = strcat('r2 = materials.',diag_name{F_tag},'.radius2;');
                    eval(evalstr);
                    R2 = r2*ratio;
                    evalstr = strcat('shape_p = parameters.geometry.polygon.polygon',num2str(F_tag),'.function(R1,R2);');
                    eval(evalstr);
                    xv = shape_p(:,1);
                    yv = shape_p(:,2);
                    in = inpolygon(x_Monte, y_Monte, xv, yv);
                    field_nodes{F_tag} = find(in==1);
                end
            end
    end
    Total = 1:num_Monte;
    TR = triangulation(mesh.elements_simple', nodes');
    ID_material = cell(num_material, 1);
    ID_background = cell(num_material, 1);
    B_material = cell(num_material, 1);
    B_background = cell(num_material, 1);
    for i = 1:num_material
         % Calculate the weighted electric field values of Monte Carlo scatter points
        ID_material{i} = pointLocation(TR, Montenodes(field_nodes{i}, :));
        B_material{i} = cartesianToBarycentric(TR, ID_material{i}, Montenodes(field_nodes{i}, :));
        Tri_material = TR.ConnectivityList(ID_material{i}, :);
        field_local_material = field(Tri_material);
        field_nodes_material = sum(field_local_material.*B_material{i}, 2);

        nodes_background = setdiff(Total, field_nodes{i});
        ID_background{i} = pointLocation(TR, Montenodes(nodes_background, :));
        B_background{i} = cartesianToBarycentric(TR, ID_background{i}, Montenodes(nodes_background, :));
        Tri_background = TR.ConnectivityList(ID_background{i}, :);
        field_local_background = field(Tri_background);
        field_nodes_background = sum(field_local_background.*B_background{i}, 2);
        average_ratio_lock_light(i) = mean(abs(field_nodes_material))/mean(abs(field_nodes_background));
        abs_ratio_lock_light(i) = sum(abs(field_nodes_material))/sum(abs(field_nodes_background));
        all_ratio_lock_light(i) = sum(abs(field_nodes_material))/(sum(abs(field_nodes_background))+sum(abs(field_nodes_material)));
    end
    field_all = [];
    for i = 1:num_material
        field_all = [field_all; field_nodes{i}];
    end
    field_all = unique(field_all);
    ID_all = pointLocation(TR, Montenodes(field_all, :));
    B_all = cartesianToBarycentric(TR, ID_all, Montenodes(field_all, :));
    Tri_material = TR.ConnectivityList(ID_all, :);
    field_local_material = field(Tri_material);
    field_nodes_material = sum(field_local_material.*B_all, 2);
    nodes_background = setdiff(Total, field_all);
    ID_background_all = pointLocation(TR, Montenodes(nodes_background, :));
    B_background_all = cartesianToBarycentric(TR, ID_background_all, Montenodes(nodes_background, :));
    Tri_background = TR.ConnectivityList(ID_background_all, :);
    field_local_background = field(Tri_background);
    field_nodes_background = sum(field_local_background.*B_background_all, 2);
    average_ratio_lock_light_all = mean(abs(field_nodes_material))/mean(abs(field_nodes_background));
    abs_ratio_lock_light_all = sum(abs(field_nodes_material))/sum(abs(field_nodes_background));
    all_ratio_lock_light_all = sum(abs(field_nodes_material))/(sum(abs(field_nodes_background)) + sum(abs(field_nodes_material)));
    [ave_max, block_index] = max(average_ratio_lock_light);
    abs_max = max(abs_ratio_lock_light);
    all_max = max(all_ratio_lock_light);
    records = [records; parameters.gamma, ratio, parameters.selected_eigencurve, block_index, ...
        ave_max, abs_max, all_max,...
        average_ratio_lock_light_all, abs_ratio_lock_light_all, all_ratio_lock_light_all];
end
figure;
yyaxis left;
p1 = plot(Ratio, records(:,10), 'b-o', 'LineWidth', 2, 'DisplayName','$E^{\mathrm{mat}}/E^{\mathrm{total}}$'); % 全介质锁光绝对值/全材料绝对值
yline(1, 'b-.', 'LineWidth', 2);
ylim([0.2,1.05])
ylabel('total field ratio', 'FontSize', 14);
yyaxis right;
p2 = plot(Ratio, records(:,8), 'r-s', 'LineWidth', 2);
ylim([6, 17])
ylabel('average field ratio', 'FontSize', 14);
xlabel('scaling factor', 'FontSize', 20);
grid on;
% legend([p1, p2], '$(\int|E^{\mathrm{mat}}|)/(\int|E^{\mathrm{total}}|)$', ' $(\int E^{\mathrm{mat}}/V^{\mathrm{mat}})/(\int E^{\mathrm{total}}/V^{\mathrm{total}})$',...
%     'Interpreter','latex','Location','southeast', 'Fontsize', 17);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'r';
set(gca, 'GridAlpha', 0.3, 'FontSize', 12);
