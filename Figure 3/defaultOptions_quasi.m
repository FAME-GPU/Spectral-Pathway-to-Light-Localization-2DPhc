function parameters = defaultOptions_quasi(parameters, lattice_type_specific, hmax, part_num)

parameters.math.is_eigenvalue_problem = 1;
parameters.fem.order = 'P1';
parameters.fem.Gauss = 4;
parameters.part_num = part_num;
parameters.poly_num_r = 1;

parameters.lattice.lattice_type = 'Parallelogram';
parameters.lattice.lattice_type_specific = lattice_type_specific;

parameters.math.boundary_conditions = {'quasiperiodic', 'Dirichlet', 'quasiperiodic', 'Dirichlet'};
% parameters.math.boundary_conditions = {'Neumann', 'Neumann', 'Neumann', 'Neumann'};
% parameters.math.boundary_conditions = {'Dirichlet', 'Dirichlet', 'Dirichlet', 'Dirichlet'};

seqlen = parameters.Fiblen;

a = 1/seqlen;
a1 = a * [seqlen*1; 0];
a2 = a * [1/2; sqrt(3)/2];
len_a1 = norm(a1);
len_a2 = norm(a2);
parameters.lattice.a = a;
parameters.lattice.a1 = a1;
parameters.lattice.a2 = a2;
parameters.lattice.len_a1 = len_a1;
parameters.lattice.len_a2 = len_a2;
parameters.mesh.hmax = hmax * len_a2;
parameters.brillouin_zone_point = 'GMXG';

parameters.recip_lattice_vec = 2 * pi * inv([a1, a2]');
% parameters.recip_lattice_vec = parameters.recip_lattice_vec./(parameters.recip_lattice_vec(2,2)/pi);


vertices = parameters.recip_lattice_vec * [0, 0.5, 0.5, 0, 0;
    0, 0, 0.5, 0.5, 0];
parameters.reciprocal_lattice.vertices = vertices;
wave_vec_array = vertices(:, 1);
for i = 1 : size(vertices, 2) - 1
    tmp1 = linspace(vertices(1, i), vertices(1, i + 1), part_num);
    tmp2 = linspace(vertices(2, i), vertices(2, i + 1), part_num);
    wave_vec_array = [wave_vec_array, [tmp1(2 : end); tmp2(2 : end)]];
end

wave_vec_array = [zeros(1,(part_num-1)*4+1); linspace(-pi/a, pi/a, (part_num-1)*4+1)];

parameters.reciprocal_lattice.wave_vec_array = wave_vec_array;
parameters.reciprocal_lattice.n_wave_vec = size(wave_vec_array, 2);


parameters.geometry.boundary.polygon.n = 4;
parameters.geometry.boundary.polygon.vertex = [0, 0; ...
    a1(1), a1(2); ...
    a1(1) + a2(1), a1(2) + a2(2); ...
    a2(1), a2(2)];

switch lattice_type_specific
    case 'parallelogram_1'
        parameters.poly_num_r = 2;
        r1 = 0.3075*a;
        r2 = 0.0615*a;
        phi = pi/3;
        theta = pi/3;
        alp = 2*pi/3;
        tag = 0;
        for iter = 1:seqlen
            tag = tag+1;
            center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
            evalstr1 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.radius1 = r1;');
            eval(evalstr1);
            evalstr2 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.radius2 = r2;');
            eval(evalstr2);
            evalstr3 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.n = ', num2str(6), ';');
            eval(evalstr3);
            Fun = @(s1, s2)[s2*cos(phi-theta), s2*sin(phi-theta); ...
                s1*cos(phi),                   s1*sin(phi); ...
                s2*cos(phi-theta+alp),	   s2*sin(phi-theta+alp);...
                s1*cos(phi+alp),             s1*sin(phi+alp);...
                s2*cos(phi-theta+2*alp),     s2*sin(phi-theta+2*alp);...
                s1*cos(phi+2*alp),	       s1*sin(phi+2*alp)] + center';

            evalstr3 = strcat('parameters.geometry.polygon.polygon', num2str(tag), '.function = Fun ;');
            eval(evalstr3);
            
            evalstr4 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.vertex = Fun(r1, r2);');
            eval(evalstr4);
        end



    case 'Fibonacci1'
        Fibo = Fibsequence(seqlen);
        r = 0.3*a;
        tag = 0;
        for iter = 1:seqlen
            if Fibo(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.circle.circle', num2str(tag),'.center = center;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.circle.circle', num2str(tag),'.radius = r;');
                eval(evalstr2);
            end 
        end

    case 'Fibonacci2'
        Fibo = Fibsequence(seqlen);
        r = 0.11*a;
        tag = 0;
        for iter = 1:seqlen
            if Fibo(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.circle.circle', num2str(tag),'.center = center;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.circle.circle', num2str(tag),'.radius = r;');
                eval(evalstr2);
            end 
        end

    case 'Fibonacci3'
        Fibo = Fibsequence(seqlen);
        r = 0.4*a;
        tag = 0;
        for iter = 1:seqlen
            if Fibo(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.radius = r;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.n = ', num2str(3), ';');
                eval(evalstr2);
                Fun = @(s)[0, s; ...
                    -sqrt(3)*s/2, -0.5*s; ...
                    sqrt(3)*s/2, -0.5*s] + center';
                evalstr3 = strcat('parameters.geometry.polygon.polygon', num2str(tag), '.function = Fun ;');
                eval(evalstr3);
                
                evalstr4 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.vertex = Fun(r);');
                eval(evalstr4);
            end 
        end

    case 'Fibonacci4'
        Fibo = Fibsequence(seqlen);
        r = 0.3*a;
        tag = 0;
        for iter = 1:seqlen
            if Fibo(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.radius = r;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.n = ', num2str(8), ';');
                eval(evalstr2);

               Fun = @(s)[0, s;
                        s/6, s/6;
                        s, 0;
                        s/6, -s/6;
                        0, -s;
                        -s/6, -s/6; 
                        -s, 0;
                        -s/6, s/6;] + center';
                evalstr3 = strcat('parameters.geometry.polygon.polygon', num2str(tag), '.function = Fun ;');
                eval(evalstr3);
                evalstr4 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.vertex = Fun(r);');
                eval(evalstr4);
            end 
        end

    case 'Octonacci1'
        Oct = Octsequence(seqlen);
        r = 0.3*a;
        tag = 0;
        for iter = 1:seqlen
            if Oct(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.circle.circle', num2str(tag),'.center = center;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.circle.circle', num2str(tag),'.radius = r;');
                eval(evalstr2);
            end 
        end

    case 'Octonacci2'
        Oct = Octsequence(seqlen);
        r = 0.11*a;
        tag = 0;
        for iter = 1:seqlen
            if Oct(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.circle.circle', num2str(tag),'.center = center;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.circle.circle', num2str(tag),'.radius = r;');
                eval(evalstr2);
            end 
        end

    case 'Octonacci3'
        Oct = Octsequence(seqlen);
        r = 0.4*a;
        tag = 0;
        for iter = 1:seqlen
            if Oct(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.radius = r;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.n = ', num2str(3), ';');
                eval(evalstr2);
                Fun = @(s)[0, s; ...
                    -sqrt(3)*s/2, -0.5*s; ...
                    sqrt(3)*s/2, -0.5*s] + center';
                evalstr3 = strcat('parameters.geometry.polygon.polygon', num2str(tag), '.function = Fun ;');
                eval(evalstr3);
                
                evalstr4 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.vertex = Fun(r);');
                eval(evalstr4);
            end 
        end

    case 'Octonacci4'
        Oct = Octsequence(seqlen);
        r = 0.3*a;
        tag = 0;
        for iter = 1:seqlen
            if Oct(iter) == 1
                tag = tag+1;
                center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
                evalstr1 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.radius = r;');
                eval(evalstr1);
                evalstr2 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.n = ', num2str(8), ';');
                eval(evalstr2);

               Fun = @(s)[0, s;
                        s/6, s/6;
                        s, 0;
                        s/6, -s/6;
                        0, -s;
                        -s/6, -s/6; 
                        -s, 0;
                        -s/6, s/6;] + center';
                evalstr3 = strcat('parameters.geometry.polygon.polygon', num2str(tag), '.function = Fun ;');
                eval(evalstr3);
                evalstr4 = strcat('parameters.geometry.polygon.polygon', num2str(tag),'.vertex = Fun(r);');
                eval(evalstr4);
            end 
        end

    % case 'Chaos'
    %     nseed = 2;
    %     rng(nseed);
    %     Chaosseq = rand(seqlen,1);
    %     Chaosseq = double(Chaosseq>0.618);
    %     r = 0.3*a;
    %     tag = 0;
    %     for iter = 1:seqlen
    %         if Chaosseq(iter) == 1
    %             tag = tag+1;
    %             center = [(iter-1)*a; 0] + ([a;0]+a2)/2;
    %             evalstr1 = strcat('parameters.geometry.circle.circle', num2str(tag),'.center = center;');
    %             eval(evalstr1);
    %             evalstr2 = strcat('parameters.geometry.circle.circle', num2str(tag),'.radius = r;');
    %             eval(evalstr2);
    %         end 
    %     end
    % 
    % 
    % case 'circle_2'
    %     r = 0.1;
    %     parameters.circle_radius = r;
    %     parameters.geometry.circle.circle1.center = (a1 + a2) / 4;
    %     parameters.geometry.circle.circle1.radius = r;
    %     parameters.circle_radius = r;
    %     parameters.geometry.circle.circle2.center = (a1 + a2) / 4 * 3;
    %     parameters.geometry.circle.circle2.radius = r;
    % case 'square_1'
    %     a_s = 0.6 / 2;
    %     parameters.a_s = a_s * 2;
    %     parameters.geometry.rectangle.rectangle1.vertex = [(0.5 - a_s) * len_a1, (0.5 - a_s) * len_a2; ...
    %         (0.5 - a_s) * len_a1, (0.5 + a_s) * len_a2; ...
    %         (0.5 + a_s) * len_a1, (0.5 + a_s) * len_a2; ...
    %         (0.5 + a_s) * len_a1, (0.5 - a_s) * len_a2];
    % case 'square_8'
    %     a_s = 0.2;
    %     parameters.a_s = a_s * 2;
    %     parameters.geometry.rectangle.rectangle1.vertex = [(0.5 - 2 * a_s) * len_a1, (0.5 - 2 * a_s) * len_a2; ...
    %         (0.5 + 1 * a_s) * len_a1, (0.5 - 2 * a_s) * len_a2; ...
    %         (0.5 + 1 * a_s) * len_a1, (0.5 - 1 * a_s) * len_a2; ...
    %         (0.5 - 2 * a_s) * len_a1, (0.5 - 1 * a_s) * len_a2];
    %     parameters.geometry.rectangle.rectangle1.pointer = sum(parameters.geometry.rectangle.rectangle1.vertex, 1) / 4;
    %     parameters.geometry.rectangle.rectangle2.vertex = [(0.5 + 1 * a_s) * len_a1, (0.5 - 2 * a_s) * len_a2; ...
    %         (0.5 + 2 * a_s) * len_a1, (0.5 - 2 * a_s) * len_a2; ...
    %         (0.5 + 2 * a_s) * len_a1, (0.5 + 1 * a_s) * len_a2; ...
    %         (0.5 + 1 * a_s) * len_a1, (0.5 + 1 * a_s) * len_a2];
    %     parameters.geometry.rectangle.rectangle2.pointer = sum(parameters.geometry.rectangle.rectangle2.vertex, 1) / 4;
    %     parameters.geometry.rectangle.rectangle3.vertex = [(0.5 - 1 * a_s) * len_a1, (0.5 + 1 * a_s) * len_a2; ...
    %         (0.5 + 2 * a_s) * len_a1, (0.5 + 1 * a_s) * len_a2; ...
    %         (0.5 + 2 * a_s) * len_a1, (0.5 + 2 * a_s) * len_a2; ...
    %         (0.5 - 1 * a_s) * len_a1, (0.5 + 2 * a_s) * len_a2];
    %     parameters.geometry.rectangle.rectangle3.pointer = sum(parameters.geometry.rectangle.rectangle3.vertex, 1) / 4;
    %     parameters.geometry.rectangle.rectangle4.vertex = [(0.5 - 2 * a_s) * len_a1, (0.5 - 1 * a_s) * len_a2; ...
    %         (0.5 - 1 * a_s) * len_a1, (0.5 - 1 * a_s) * len_a2; ...
    %         (0.5 - 1 * a_s) * len_a1, (0.5 + 2 * a_s) * len_a2; ...
    %         (0.5 - 2 * a_s) * len_a1, (0.5 + 2 * a_s) * len_a2];
    %     parameters.geometry.rectangle.rectangle4.pointer = sum(parameters.geometry.rectangle.rectangle4.vertex, 1) / 4;
end

end