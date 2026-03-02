%% Figure 6

clear
clc
close all

%% Figure 6a -- localization
warning('off');
draw_composite_figure('./data_gamma/gamma=8.0400000.mat', 'Cylinders');

function draw_composite_figure(filepath, geometry_type)
    p_cyl.n_theta = 60; p_cyl.n_z = 20;
    p_cyl.z_bot1=0.264771; p_cyl.z_top1=0.617614;
    p_cyl.z_bot2=p_cyl.z_top1; p_cyl.z_top2=0.735229;
    p_cyl.r_big=0.3321; p_cyl.r_small=0.75*0.3321;
    p_cube.size = 0.49; 
    p_cube.base1 = [0.01, 0.01, 0.01]; 
    p_cube.base2 = [0.99-p_cube.size, 0.99-p_cube.size, 0.99-p_cube.size];
    p_sphere.radius = 0.5; p_sphere.center = [0.5, 0.5, 0.5];

    raw = load(filepath);
    result = raw.result; opt = result.opt;
    [~, fname, ~] = fileparts(filepath);
    tokens = regexp(fname, 'gamma=([\d\.]+)', 'tokens');
    if ~isempty(tokens)
        gamma_val = str2double(tokens{1}{1}); 
    else
        gamma_val=0; 
    end
    
    A = opt.phys.lattice.lattice_vector; 
    dim = opt.comp.Dim.n1;
    
    gather_func = @(x) x; 
    try
        gather_func = @(x) gather(x); 
    catch
    end 
    tasks = {
        {gather_func(result.Eigenmode.e1(:,1)), 'E_x'},
        {gather_func(result.Eigenmode.e2(:,1)), 'E_y'},
        {gather_func(result.Eigenmode.e3(:,1)), 'E_z'},
        {gather_func(result.Eigenmode.h1(:,1)), 'H_x'},
        {gather_func(result.Eigenmode.h2(:,1)), 'H_y'},
        {gather_func(result.Eigenmode.h3(:,1)), 'H_z'}
    };
    [Vx, Vy, Vz] = ndgrid([0 1]);
    V_lat_corners = [Vx(:), Vy(:), Vz(:)];
    V_cart_corners = (A * V_lat_corners')'; 
    global_xlim = [min(V_cart_corners(:,1)), max(V_cart_corners(:,1))];
    global_ylim = [min(V_cart_corners(:,2)), max(V_cart_corners(:,2))];
    global_zlim = [min(V_cart_corners(:,3)), max(V_cart_corners(:,3))];
    margin = 0.02;
    global_xlim = global_xlim + [-margin, margin];
    global_ylim = global_ylim + [-margin, margin];
    global_zlim = global_zlim + [-margin, margin];

alpha_base  = 0.04;  
alpha_scale = 1 - alpha_base; 
alpha_pow   = 1.5;   
max_E = 0; max_H = 0;
for i = 1:3
    max_E = max(max_E, max(abs(tasks{i}{1}(:)))); 
end
for i = 4:6
    max_H = max(max_H, max(abs(tasks{i}{1}(:)))); 
end
if max_E == 0
    max_E = 1; 
end
if max_H == 0
    max_H = 1; 
end

f = figure('Color','w', 'Position', [10, 10, 2000, 900], 'Visible', 'on');
ax_geo_pos = [0.04, 0.08, 0.22, 0.85];  

right_start = 0.28;    
right_width = 0.68;   
right_height = 0.85;   
col_spacing = 0.008;     
row_spacing = 0.01;     
tile_width = (right_width - 2*col_spacing) / 3;  
tile_height = (right_height - row_spacing) / 2;

ax_geo = axes('Position', ax_geo_pos); 
hold(ax_geo, 'on');
draw_lattice_box(ax_geo, A); 
render_geometry_content(ax_geo, geometry_type, A, p_cyl, p_cube, p_sphere);
view(ax_geo, 30, 30); 
axis(ax_geo, 'equal', 'off', 'tight');
xlim(ax_geo, global_xlim); ylim(ax_geo, global_ylim); zlim(ax_geo, global_zlim);
grid_lin = linspace(0, 1, dim);
[XX, YY, ZZ] = meshgrid(grid_lin, grid_lin, grid_lin);
field_labels = {
    '$E_x$', '$E_y$', '$E_z$', ...
    '$H_x$', '$H_y$', '$H_z$'
};
for row = 1:2
    for col = 1:3
        idx = (row-1)*3 + col;
        left = right_start + (col-1)*(tile_width + col_spacing);
        bottom = 0.1 + (2-row)*(tile_height + row_spacing);  % 从下往上计算
        ax = axes('Position', [left, bottom, tile_width, tile_height]);
        hold(ax, 'on');
        data = tasks{idx}{1};
        is_E_field = (idx <= 3);
        current_max = is_E_field * max_E + (~is_E_field) * max_H;
        v_abs = abs(data);
        VV = reshape(v_abs, dim, dim, dim);
        mask = ~isnan(VV); 
        P_lat = [XX(mask)'; YY(mask)'; ZZ(mask)'];
        P_real = A * P_lat;
        x_p = P_real(1,:)'; y_p = P_real(2,:)'; z_p = P_real(3,:)';
        v_p = VV(mask);
        if ~isempty(x_p)
            v_ratio = v_p / current_max; v_ratio(v_ratio > 1) = 1; 
            alpha_data = alpha_base + alpha_scale * v_ratio.^alpha_pow; 
            alpha_data(alpha_data > 1) = 1;
            scatter3(ax, x_p, y_p, z_p, 30, v_p, 'filled', ...
                'MarkerEdgeColor','none', 'MarkerFaceAlpha','flat', 'AlphaData',alpha_data);
        end
        colormap(ax, 'parula'); 
        caxis(ax, [0, current_max]);

        draw_lattice_box(ax, A); 

        view(ax, 30, 30); 
        axis(ax, 'equal', 'off', 'tight');
        xlim(ax, global_xlim); ylim(ax, global_ylim); zlim(ax, global_zlim);
        title_pos = [mean(global_xlim), mean(global_ylim), global_zlim(2)*1.05];
        text(ax, title_pos(1), title_pos(2), title_pos(3), ...
            field_labels{idx}, ...
            'Interpreter', 'latex', 'FontSize', 16, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom', ...
            'FontWeight', 'bold');
        if col == 3
            cb = colorbar(ax); 
            cb.FontName = 'Courier New'; 
            cb.FontSize = 12;
            cb.FontWeight = 'bold';
            cb_pos = cb.Position;
            cb.Position = [cb_pos(1)+0.01, cb_pos(2), cb_pos(3)*0.8, cb_pos(4)*0.9];
        end
    end
end
end

function draw_lattice_box(ax, A)
    faces = [1 2 4 3; 5 6 8 7; 1 2 6 5; 3 4 8 7; 1 3 7 5; 2 4 8 6];
    [Vx, Vy, Vz] = ndgrid([0 1]);
    V_lat = [Vx(:), Vy(:), Vz(:)];
    V_cart = (A * V_lat')'; 
    patch(ax, 'Vertices', V_cart, 'Faces', faces, ...
        'FaceColor', 'none', ...    
        'EdgeColor', 'k', ...       
        'LineWidth', 1.5, ...       
        'LineStyle', '-');
end

function render_geometry_content(ax, type, A, p_cyl, p_cube, p_sphere)
    faces = [1 2 4 3; 5 6 8 7; 1 2 6 5; 3 4 8 7; 1 3 7 5; 2 4 8 6];
    
    switch type
        case 'Cylinders'
            [X1, Y1, Z1] = get_cyl_mesh(p_cyl.z_bot1, p_cyl.z_top1, p_cyl.r_big, p_cyl.n_theta, p_cyl.n_z, A);
            surf(ax, X1, Y1, Z1, 'FaceColor','r', 'FaceAlpha', 0.6, 'EdgeColor','none');
            [X2, Y2, Z2] = get_cyl_mesh(p_cyl.z_bot2, p_cyl.z_top2, p_cyl.r_small, p_cyl.n_theta, p_cyl.n_z, A);
            surf(ax, X2, Y2, Z2, 'FaceColor','r', 'FaceAlpha', 0.6, 'EdgeColor','none');
            
        case 'Cubes'
            V1 = get_cube_vertices(p_cube.base1, p_cube.size);
            patch(ax, 'Vertices', (A*V1')', 'Faces', faces, 'FaceColor','r', 'FaceAlpha',0.6, 'EdgeColor','none');
            V2 = get_cube_vertices(p_cube.base2, p_cube.size);
            patch(ax, 'Vertices', (A*V2')', 'Faces', faces, 'FaceColor','r', 'FaceAlpha',0.6, 'EdgeColor','none');
            
        case 'Sphere'
            [sx, sy, sz] = sphere(60);
            c_real = A * p_sphere.center';
            Xr = c_real(1) + p_sphere.radius * sx;
            Yr = c_real(2) + p_sphere.radius * sy;
            Zr = c_real(3) + p_sphere.radius * sz;
            surf(ax, Xr, Yr, Zr, 'FaceColor','r', 'FaceAlpha',0.6, 'EdgeColor','none');
    end
end

function [X_r, Y_r, Z_r] = get_cyl_mesh(z_bot, z_top, r, n_theta, n_z, A)
    theta = linspace(0, 2*pi, n_theta);
    z = linspace(z_bot, z_top, n_z)';
    [TT, ZZ] = meshgrid(theta, z);
    X_l = 0.5 + r .* cos(TT);
    Y_l = 0.5 + r .* sin(TT);
    Z_l = ZZ;
    coords_r = A * [X_l(:)'; Y_l(:)'; Z_l(:)'];
    X_r = reshape(coords_r(1,:), size(X_l));
    Y_r = reshape(coords_r(2,:), size(Y_l));
    Z_r = reshape(coords_r(3,:), size(Z_l));
end

function V = get_cube_vertices(base, s)
    x0 = base(1); y0 = base(2); z0 = base(3);
    V = [x0 y0 z0; x0+s y0 z0; x0 y0+s z0; x0+s y0+s z0;
         x0 y0 z0+s; x0+s y0 z0+s; x0 y0+s z0+s; x0+s y0+s z0+s];
end


%% Figure 6b & 6c -- localized ratio
gamma_array = 8.01:0.01:8.10;
radius_array = 1.0:0.01:1.3;
lock_rate1 = zeros(length(gamma_array), length(radius_array));
lock_rate2 = zeros(length(gamma_array), length(radius_array));
lock_rate1_e = zeros(length(gamma_array), length(radius_array), 3 * 2);
lock_rate1_h = zeros(length(gamma_array), length(radius_array), 3 * 2); 
lock_rate2_e = zeros(length(gamma_array), length(radius_array), 3 * 2);
lock_rate2_h = zeros(length(gamma_array), length(radius_array), 3 * 2); 
for gamma_idx = 1:length(gamma_array)    
    gamma = gamma_array(gamma_idx);
    fprintf("=============now gamma is %d=============\n", gamma);
    filename1 = sprintf('./data_gamma/gamma=%.7f.mat', gamma);
    output = evalc('load(filename1)');
    e1 = gather(result.Eigenmode.e1); e2 = gather(result.Eigenmode.e2); e3 = gather(result.Eigenmode.e3);
    h1 = gather(result.Eigenmode.h1); h2 = gather(result.Eigenmode.h2); h3 = gather(result.Eigenmode.h3);    
    e_all = {e1,e2,e3};
    h_all = {h1,h2,h3};
    for k = 1:3
        e_tmp = gather(e_all{k});
        h_tmp = gather(h_all{k});
        for i = 1:2
            v_e = e_tmp(:,i);
            v_h = h_tmp(:,i);
            for radius_rate_idx = 1:length(radius_array)
                radius_rate = radius_array(radius_rate_idx);
                filename2 = sprintf('./data_radius/radius_rate=%.2f.mat', radius_rate);
                output = evalc('load(filename2)'); 
                idx_e = Standard_inner_idx;
                idx_h = Bodycenter_inner_idx;
                tmp1_e = sum(abs(v_e));
                tmp2_e = sum(abs(v_e(idx_e))); 
                tmp3_e = tmp1_e - tmp2_e;
                lock_rate1_e(gamma_idx, radius_rate_idx, 2 * (k-1) + i) = tmp2_e / tmp1_e; 
                lock_rate2_e(gamma_idx, radius_rate_idx, 2 * (k-1) + i) = tmp2_e / tmp3_e;
                tmp1_h = sum(abs(v_h));
                tmp2_h = sum(abs(v_h(idx_h)));
                tmp3_h = tmp1_h - tmp2_h;      
                lock_rate1_h(gamma_idx, radius_rate_idx, 2 * (k-1) + i) = tmp2_h / tmp1_h;
                lock_rate2_h(gamma_idx, radius_rate_idx, 2 * (k-1) + i) = tmp2_h / tmp3_h;
            end
        end
    end
end
for field_type = 1:2
    if field_type == 1
        lock_rate1 = lock_rate1_e;
        field_name = 'Electric Field';
    else
        lock_rate1 = lock_rate1_h;
        field_name = 'Magnetic Field';
    end
    fig = figure('Visible', 'on');
    hold on;
    for k = 1:3  
        for i = 1:2  
            mode_idx = 2*(k-1) + i;
            subplot(3, 2, mode_idx);
            hold on;
            gamma_labels = {};
            for gamma_idx = 1:length(gamma_array)
                gamma = gamma_array(gamma_idx);
                plot(radius_array, lock_rate1(gamma_idx, :, mode_idx));
                current_label = sprintf('Gamma: %.4f', gamma);
                gamma_labels{end+1} = current_label;
            end
            xlabel('scaling factor');
            ylabel('ratio');
            if field_type == 1
                title(sprintf('$E_%d(%d)$', k, i), 'Interpreter', 'latex');
            else
                title(sprintf('$H_%d(%d)$', k, i), 'Interpreter', 'latex');
            end
        end
    end
    sgtitle(sprintf('%s', field_name));
end
