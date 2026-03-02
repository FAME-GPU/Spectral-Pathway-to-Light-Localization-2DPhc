
clear
clc
close all

%% Figure 2b
load('eig_for_band_structure.mat')
knum = 31;
frenum = 20;
[row, col] = size(eig_sort);
fre = zeros(row, col/2);
for i = 1:col/2
    fre(1, i) = eig_sort(1, 2 * i);
    fre(2 : end, i) = eig_sort(2 : end, 2 * i - 1) + 1i * eig_sort(2 : end, 2 * i);
end

% localization gamma
gamma = 12.1654;
index1 = 202;
banddata = fre(2 : end, index1);
frequency = reshape(banddata, [frenum, knum]);
figure('Position', [100, 100, 1000, 600]);
set(gcf, 'Color', 'white');
denseline = frequency;
% distinguish newborn & original eigenvalues
denseline(2, [8:9,25:26]) = frequency(3, [8:9,25:26]);
denseline(2, [10:19,23:24]) = frequency(4, [10:19,23:24]);
denseline(2, 20:22) = frequency(5, 20:22);
denseline(3, 8:26) = frequency(2, 8:26);
denseline(4, 10:24) = frequency(3, 10:24);
denseline(5, 10:14) = frequency(6, 10:14);
denseline(5, 20:22) = frequency(4, 20:22);
denseline(6, 10:14) = frequency(5, 10:14);
colors = lines(4);
p1 = []; p2 = []; p3 = [];
for i = 1:frenum
    if imag(denseline(i,1)) > 1e-6
        if isempty(p1) 
            p1 = plot(imag(denseline(i,:)), ':', 'Color', 'r', 'LineWidth', 2.5, ...
                'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
        else
            plot(imag(denseline(i,:)), ':', 'Color', 'r', 'LineWidth', 2.5, ...
                'Marker', 'o', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
        end
        hold on
    elseif ismember(i, [3,4,5])
        if isempty(p2) 
            p2 = plot(real(denseline(i,:)), '--', 'Color', 'b', 'LineWidth', 2.5, ...
                'Marker', 's', 'MarkerSize', 5, 'MarkerFaceColor', 'b');
        else
            plot(real(denseline(i,:)), '--', 'Color', 'b', 'LineWidth', 2.5, ...
                'Marker', 's', 'MarkerSize', 5, 'MarkerFaceColor', 'b');
        end
    else
        if isempty(p3) 
            p3 = plot(real(denseline(i,:)), '-', 'Color', 'm', 'LineWidth', 1.5, ...
                'Marker', '.', 'MarkerSize', 8);
        else
            plot(real(denseline(i,:)), '-', 'Color', 'm', 'LineWidth', 1.5, ...
                'Marker', '.', 'MarkerSize', 8, 'MarkerFaceColor', 'm');
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




%% Figure 2c                  
eigenresult = load('eigenvalue_vector.mat');
load('mesh.mat');                     
load('parameters.mat');              
result = eigenresult.result;
parameters.selected_eigencurve = 3;
parameters.selected_wave_vec = 16;  

num_Monte = parameters.num_Monte;
ka = parameters.ka;
records = [];
% select eigenvalue and eigenvector
ev_select = result{parameters.selected_wave_vec}.ev(:, parameters.selected_eigencurve);
ew_select = result{parameters.selected_wave_vec}.ew(parameters.selected_eigencurve);
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

figure
abs_q1_all = abs(field);
patch('Faces', elements(1 : 3, :).', 'Vertices', nodes.', 'FaceVertexCData', abs_q1_all, ...
    'FaceColor', 'interp', 'EdgeColor', 'interp'), hold on
colorbar
axis equal
axis off

%% Figure 2d
load('./eig_sort_dense.mat');
[row, col] = size(eig_sort);
frenum = 20; knum = 31;
fre = zeros(row, col/2);
Seqgamma = 12.16:1e-5:12.17;
for i = 1:col/2
    fre(1, i) = eig_sort(1,2*i);
    fre(2:end,i) = eig_sort(2:end,2*i-1) + 1i*eig_sort(2:end,2*i);
end
k = 16;
gamma_seq = fre(1,:);
l_gamma = length(gamma_seq);
gamma_kfre = zeros(frenum, l_gamma+2);
for i = 1:l_gamma
    gamma = gamma_seq(i);
    index1 = find(fre(1,:) == gamma);
    banddata = fre(2:end, index1);
    frequency = reshape(banddata, [frenum, knum]);
    gamma_kfre(:,i) = frequency(:,k);
end
gamma_kfre(:,618:end) = gamma_kfre(:,616:end-2);
gamma_kfre(:,616) = (gamma_kfre(:,615) + gamma_kfre(:,618))/2;
gamma_kfre(:,617) = (gamma_kfre(:,618));
gamma_kfre(:,618) = (gamma_kfre(:,618) + gamma_kfre(:,619))/2;
frenum = 4;
% select Bloch vector kth = 16 with gamma between 12.16 and 12.17
figure('Position', [100, 100, 1000, 700]);
set(gcf, 'Color', 'white');
hax = axes('Position', [0.12, 0.15, 0.8, 0.75]);
colors = lines(3);
p1_main = []; p2_main = []; p3_main = [];
for i = 1:frenum
    for j = 1:l_gamma
        if abs(real(gamma_kfre(i, j))) > 1e-6
            if isempty(p1_main) 
                p1_main = plot(hax, Seqgamma(j), real(gamma_kfre(i, j)), ...
                    'o', 'Color', 'b', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
            else
                plot(hax, Seqgamma(j), real(gamma_kfre(i, j)), ...
                    'o', 'Color', 'b', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
            end
            hold on;
        elseif abs(imag(gamma_kfre(i, j))) > 1e-6
            if isempty(p2_main) 
                p2_main = plot(hax, Seqgamma(j), imag(gamma_kfre(i, j)), ...
                    's', 'Color', 'r', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
            else
                plot(hax, Seqgamma(j), imag(gamma_kfre(i, j)), ...
                    's', 'Color', 'r', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
            end
            hold on;
        else
            if isempty(p3_main) 
                p3_main = plot(hax, Seqgamma(j), abs(gamma_kfre(i, j)), ...
                    '^', 'Color', colors(3,:), 'MarkerSize', 4, 'MarkerFaceColor', colors(3,:));
            else
                plot(hax, Seqgamma(j), abs(gamma_kfre(i, j)), ...
                    '^', 'Color', colors(3,:), 'MarkerSize', 4, 'MarkerFaceColor', colors(3,:));
            end
            hold on;
        end
    end
end
axis([12.16 12.17 0 1.05*max(max(abs(gamma_kfre)))]);
xticks(12.16:0.002:12.17);
xlabel('parameter $\gamma$', 'Interpreter', 'latex', 'FontSize', 56);
ylabel('frequency $\omega a/(2\pi c)$', 'Interpreter', 'latex', 'FontSize', 56);
grid on;
set(gca, 'GridAlpha', 0.3, 'FontSize', 18);
legend([p1_main, p2_main], 'newborn real eigenvalues', 'imaginary eigenvalues', ...
    'FontSize', 20, 'Location', 'southwest', 'Box', 'on');
% Observe the transition from imag to real root in the enlarged view between 12.1652 and 12.1664
zoom_x = [12.1652, 12.1664];
zoom_y = [0, 0.8];
rectangle('Position', [zoom_x(1), zoom_y(1), zoom_x(2)-zoom_x(1), zoom_y(2)-zoom_y(1)], ...
          'EdgeColor', 'm', 'LineWidth', 2, 'LineStyle', '--');
axes2 = axes('Position', [0.47, 0.55, 0.33, 0.33]);
box on;
p1_zoom = []; p2_zoom = [];
for i = 1:frenum
    for j = 1:l_gamma
        if abs(real(gamma_kfre(i, j))) > 1e-6
            if isempty(p1_zoom) 
                p1_zoom = plot(axes2, Seqgamma(j), real(gamma_kfre(i, j)), ...
                    'o', 'Color', 'b', 'MarkerSize', 3, 'MarkerFaceColor', 'b');
            else
                plot(axes2, Seqgamma(j), real(gamma_kfre(i, j)), ...
                    'o', 'Color', 'b', 'MarkerSize', 3, 'MarkerFaceColor', 'b');
            end
            hold on;
        elseif abs(imag(gamma_kfre(i, j))) > 1e-6
            if isempty(p2_zoom) 
                p2_zoom = plot(axes2, Seqgamma(j), imag(gamma_kfre(i, j)), ...
                    's', 'Color', 'r', 'MarkerSize', 3, 'MarkerFaceColor', 'r');
            else
                plot(axes2, Seqgamma(j), imag(gamma_kfre(i, j)), ...
                    's', 'Color', 'r', 'MarkerSize', 3, 'MarkerFaceColor', 'r');
            end
            hold on;
        else
            plot(axes2, Seqgamma(j), abs(gamma_kfre(i, j)), ...
                '^', 'Color', colors(3,:), 'MarkerSize', 3, 'MarkerFaceColor', colors(3,:));
            hold on;
        end
    end
end
xlim(axes2, [12.1652, 12.1664]);
ylim(axes2, [0, 0.8]);
grid on;
set(axes2, 'FontSize', 12);
set(axes2, 'LineWidth', 1.5, 'XColor', 'k', 'YColor', 'k');
legend(axes2, 'off');
main_zoom_center_x = (zoom_x(1) + zoom_x(2)) / 2;
main_zoom_center_y = (zoom_y(1) + zoom_y(2)) / 2;
main_pos = get(hax, 'Position');
main_x_range = [12.16, 12.17];
main_y_range = [0, 1.05*max(max(abs(gamma_kfre)))];
main_norm_x = main_pos(1) + (main_zoom_center_x - main_x_range(1)) / (main_x_range(2) - main_x_range(1)) * main_pos(3);
main_norm_y = main_pos(2) + (main_zoom_center_y - main_y_range(1)) / (main_y_range(2) - main_y_range(1)) * main_pos(4);
main_norm_y = main_norm_y + 0.15;
zoom_pos = get(axes2, 'Position');
zoom_center_x = zoom_pos(1) + zoom_pos(3)/2;
zoom_center_y = zoom_pos(2) - 0.04;
annotation('line', [main_norm_x, zoom_center_x], [main_norm_y, zoom_center_y], ...
           'Color', 'm', 'LineStyle', '--', 'LineWidth', 2);
annotation('arrow', [main_norm_x, zoom_center_x], [main_norm_y, zoom_center_y], ...
           'Color', 'm', 'LineWidth', 1.5, 'HeadStyle', 'vback2', 'HeadSize', 6);

%% Figure 2e
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
                    evalstr = strcat('shape = parameters.geometry.polygon.polygon',num2str(F_tag),'.function(Radius);');
                    eval(evalstr);
                    xv = shape(:,1);
                    yv = shape(:,2);
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
                    evalstr = strcat('shape = parameters.geometry.polygon.polygon',num2str(F_tag),'.function(R1,R2);');
                    eval(evalstr);
                    xv = shape(:,1);
                    yv = shape(:,2);
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
ylim([0.4,1.05])
ylabel('total field ratio', 'FontSize', 14);
yyaxis right;
p2 = plot(Ratio, records(:,8), 'r-s', 'LineWidth', 2);
ylim([0, 18])
ylabel('average field ratio', 'FontSize', 14);
xlabel('scaling factor', 'FontSize', 20);
grid on;
% legend([p1, p2], '$(\int|E^{\mathrm{mat}}|)/(\int|E^{\mathrm{total}}|)$', ' $(\int E^{\mathrm{mat}}/V^{\mathrm{mat}})/(\int E^{\mathrm{total}}/V^{\mathrm{total}})$',...
%     'Interpreter','latex','Location','southeast', 'Fontsize', 17);
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'r';
set(gca, 'GridAlpha', 0.3, 'FontSize', 12);

