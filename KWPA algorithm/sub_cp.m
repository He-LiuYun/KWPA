function [posi_all] = sub_cp(xmin, xmax, ymin, ymax, zmin, zmax,npoints,num_m, min_distance, v_min, v_max)
% 初始化点位置
posi_all = zeros(3, npoints, num_m);
count = 0;
attempts = 0;
max_attempts = 1e6;
while count < npoints && attempts < max_attempts
    new_point = [xmin + (xmax - xmin) * rand();
                 ymin + (ymax - ymin) * rand();
                 zmin + (zmax - zmin) * rand()];
    if count < 1
        is_valid = true;
    else
        distances = sqrt(sum((posi_all(:, 1:count, 1) - new_point).^2, 1));
        is_valid = all(distances >= min_distance);
    end
    if is_valid
        count = count + 1;
        posi_all(:, count, 1) = new_point;
    end
    attempts = attempts + 1;
end
if count < npoints
    error('初始化失败，请调整最小距离或空间大小');
end


% 初始化参数
dt = 1;                    % 时间步长
noise_amp = 3;           % 随机扰动强度
cohesion_weight = 0.01;    % 聚合力权重
separation_weight = 2;   % 斥力权重
% 轨迹更新（从第2帧开始）
for q = 2:num_m
    posi_prev = posi_all(:, :, q-1);
    posi_new = posi_prev;
    for i = 1:npoints
        % 当前点
        pi = posi_prev(:, i);
        
        % 找到邻居
        neighbors = [];
        for j = 1:npoints
            if j == i, continue; end
            dist = norm(pi - posi_prev(:, j));
            if dist <= min_distance*3
                neighbors = [neighbors, j];
            end
        end

        % === 聚合力 ===
        F_cohesion = zeros(3,1);
        if ~isempty(neighbors)
            center = mean(posi_prev(:, neighbors), 2);
            F_cohesion = (center - pi)/length(neighbors);
        end

        % === 斥力 ===
        F_separation = zeros(3,1);
        for j = neighbors
            diff = pi - posi_prev(:, j);
            dist_sq = norm(diff)^2 + 1e-6;  % 防止除以0
            if dist_sq < min_distance*2
                F_separation = F_separation + diff / dist_sq;
            end
        end

        % === 随机扰动 ===
        F_noise = noise_amp * randn(3,1);

        % === 合力更新速度和位置 ===
        v_new = cohesion_weight * F_cohesion + separation_weight * F_separation + F_noise;

        % 限制最大速度
        speed = norm(v_new);
        if speed > v_max
            v_new = (v_new / speed) * v_max;
        elseif speed < v_min
            v_new = (v_new / speed) * v_min;
        end

        % 更新位置
        p_new = pi + v_new * dt;

        % 边界控制（反弹）
        p_new(1) = reflect(p_new(1), xmin, xmax);
        p_new(2) = reflect(p_new(2), ymin, ymax);
        p_new(3) = reflect(p_new(3), zmin, zmax);

        posi_new(:, i) = p_new;
    end
    posi_all(:, :, q) = posi_new;
end



end