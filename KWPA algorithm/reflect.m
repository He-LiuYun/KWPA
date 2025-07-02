% 辅助函数：边界反弹
function val = reflect(val, minv, maxv)
    if val < minv
        val = minv + (minv - val);
    elseif val > maxv
        val = maxv - (val - maxv);
    end
end